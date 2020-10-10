# frozen_string_literal: true

class BandsController < ApplicationController
  before_action :authenticate_user!
  def index
    @q = Band.ransack(params[:q])
    @collections = User.pluck(:name, :id).unshift(['募集中', 0])
    @bands = @q.result.includes(:users, :relationships).distinct(true).kaminari_page(params[:page])
  end

  def new
    @band = Band.new
    @band.relationships.build
  end

  def create
    create_permission
    @band = Band.new(@new_band_params)
    if validate_create(band_params)
      if @band.save
        notifications
        redirect_to @band
        flash[:notice] = 'バンドの登録に成功しました'
      else
        flash[:alert] = 'バンドの登録に失敗しました'
        render 'new'
      end
    else
      @band.errors.add(:base, '作成者は必ずバンドに所属してください')
      flash[:alert] = 'バンドの登録に失敗しました'
      render 'new'
    end
  end

  def edit
    @band = Band.find(params[:id])
    @members = @band.users
    are_you_member?
  end

  def update
    @band = Band.find(params[:id])
    update_permission_and_destroy_check
    if @band.save
      notifications
      if @band.users.any? # update時にメンバーが存在しなかった場合バンドを削除する
        redirect_to @band
        flash[:notice] = 'バンド情報の編集に成功しました'
      else
        # バンド削除通知を作成
        user_ids = Relationship.where(band_id: @band.id, permission: true).where.not(user_id: current_user.id).select(:user_id)
        members = User.where(id: user_ids) # 既存のメンバー
        members.each do |member|
          @destroy_band_notification = current_user.active_notifications.new(
            visited_id: member.id,
            destroy_band: @band.name,
            action: 'band_destroy'
          )
          @destroy_band_notification.save if @destroy_band_notification.valid?
        end
        @band.destroy
        redirect_to @band
        flash[:alert] = 'メンバー不在のためバンドを削除しました'
      end
    else
      render 'edit'
      flash[:alert] = 'バンド情報の編集に失敗しました'
    end
  end

  def show
    @band = Band.find(params[:id])
    @members = Relationship.where(band_id: @band.id) # @band.usersだとuser_id:0のレコードを取得できない
    @users = @band.users
    unless @band.users.any? # なにかの不具合でメンバーがいないバンドが出来てしまった場合削除する
      @band.destroy
      redirect_to @band
      flash[:alert] = '何らかの理由によりメンバーが不在になったためバンドを削除しました'
    end
  end

  def destroy
    @band = Band.find(params[:id])
    @members = @band.users
    user_ids = Relationship.where(band_id: @band.id, permission: true).where.not(user_id: current_user.id).select(:user_id)
    members = User.where(id: user_ids) # 招待を承認済みかつ自分を覗いたバンドメンバーを取得する
    are_you_member?
    members.each do |member| # バンド削除通知のインスタンスを作っておく 削除に成功した場合のみsaveする
      @destroy_band_notification = current_user.active_notifications.new(
        visited_id: member.id,
        destroy_band: @band.name,
        action: 'band_destroy'
      )
    end
    if @band.destroy
      @destroy_band_notification&.save
      redirect_to bands_path
      flash[:notice] = '削除に成功しました'
    else
      flash[:alert] = '削除に失敗しました'
      render @band
    end
  end

  # バンドメンバー以外が情報を編集しようとした場合ホームにリダイレクトする
  def are_you_member?
    unless @members.any? { |v| v.id.to_i == current_user.id } && Relationship.where(user_id: current_user.id, band_id: @band.id)
      redirect_to root_path
      flash[:alert] = '権限がありません'
    end
  end

  # バンドを作成するときcurrent_userは必ず所属しなければならない
  def validate_create(relations)
    if relations[:relationships_attributes]
      relations.to_unsafe_h[:relationships_attributes].any? { |_k, v| v['user_id'].to_i == current_user.id }
    end
  end

  # createアクション時、バンド作成者は自動的にpermissionをtrueにする
  def create_permission
    if band_params[:relationships_attributes]
      beta_band_params = band_params[:relationships_attributes].each do |_k, v|
        v['permission'] = true if v['user_id'].to_i == current_user.id
      end
      @new_band_params = { name: band_params[:name], image: band_params[:image], relationships_attributes: beta_band_params.to_unsafe_h }
    end
  end

  # updateアクション時、band_paramsのpermissionとdestroy_checkを操作
  def update_permission_and_destroy_check
    if band_params[:relationships_attributes]
      beta_band_params = band_params[:relationships_attributes].each do |_k, v|
        v['permission'] = true if v['user_id'].to_i == current_user.id # 編集者のpermissionはtrueにする
        v['destroy_check'] = true if v['_destroy'] == '1' # band.rbのresource_be_uniqで使用
        next unless Relationship.find_by(user_id: v['user_id'].to_i, band_id: @band.id) # 新規レコードかどうかを判別

        v['permission'] = true if Relationship.find_by(user_id: v['user_id'].to_i, band_id: @band.id).permission == true
        # paramsのpermissionはデフォルトでfalseが送信されるため、レコードのpermissionがtrueの場合上書きされないようにする
      end
      @new_band_params = { name: band_params[:name], image: band_params[:image], relationships_attributes: beta_band_params.to_unsafe_h }
      # 変更したパラメータを保存する
      @band.update(@new_band_params)
    end
  end

  def notifications
    user_ids = Relationship.where(band_id: @band.id, permission: true).where.not(user_id: current_user.id).select(:user_id)
    members = User.where(id: user_ids) # 招待を承認済みかつ自分を覗いたバンドメンバーを取得する
    @new_band_params[:relationships_attributes].each do |_k, v|
      # paramsが募集中なら通知を送らない
      next if v['user_id'] == '0'

      # _destroy == 1なら除名通知か招待キャンセル通知を送る
      if v['_destroy'] == '1'
        # permission == trueなら除名通知 そうでないならキャンセル通知
        if v['permission'] == true
          # メンバーに除名通知を送る
          members.each do |member|
            quit_other_notification = current_user.active_notifications.new(
              band_id: @band.id,
              visited_id: member.id,
              optional_id: v['user_id'].to_i,
              action: 'quit_other'
            )
            quit_other_notification.save if quit_other_notification.valid?
          end
          # 本人に除名通知を送る
          quit_notification = current_user.active_notifications.new(
            band_id: @band.id,
            visited_id: v['user_id'].to_i,
            action: 'quit'
          )
          quit_notification.save if quit_notification.valid?
        else
          # メンバーに除名通知を送る
          members.each do |member|
            cancel_other_notification = current_user.active_notifications.new(
              band_id: @band.id,
              visited_id: member.id,
              optional_id: v['user_id'].to_i,
              action: 'cancel_other'
            )
            cancel_other_notification.save if cancel_other_notification.valid?
          end
          # 本人に除名通知を送る
          cancel_notification = current_user.active_notifications.new(
            band_id: @band.id,
            visited_id: v['user_id'].to_i,
            action: 'cancel'
          )
          cancel_notification.save if cancel_notification.valid?
        end
      else
        # 招待通知を送る
        temp = Notification.where(['visited_id = ? and band_id = ? and action = ? ', v['user_id'].to_i, @band.id, 'invitation']) # 既にレコードが存在する場合作成しない
        next unless temp.blank?

        invitation_notification = current_user.active_notifications.new(
          band_id: @band.id,
          visited_id: v['user_id'].to_i,
          relationship_id: Relationship.find_by(band_id: @band.id, user_id: v['user_id'].to_i).id,
          action: 'invitation'
        )
        invitation_notification.save if invitation_notification.valid?
        # optional_idとcurrent_userが一致した通知を作成しない (例 伊藤さんが伊藤さんを招待しました)
        next if v['user_id'].to_i == current_user.id
        # 既存のメンバーに招待したことを通知する
        next unless members

        members.each do |member|
          invitation_other_notification = current_user.active_notifications.new(
            band_id: @band.id,
            visited_id: member.id,
            relationship_id: Relationship.find_by(band_id: @band.id, user_id: v['user_id'].to_i).id,
            optional_id: v['user_id'].to_i,
            action: 'invitation_other'
          )
          invitation_other_notification.save if invitation_other_notification.valid?
        end
      end
    end
  end

  private

  def band_params
    params.require(:band).permit(
      :name,
      :image,
      relationships_attributes: %i[
        id
        part
        band_id
        user_id
        permission
        _destroy
      ]
    )
   end
end

