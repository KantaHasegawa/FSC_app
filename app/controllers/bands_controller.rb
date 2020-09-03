class BandsController < ApplicationController
  before_action :authenticate_user!
  def index
    @q = Band.ransack(params[:q])
    @collections = User.pluck(:name, :id).unshift(['募集中', 0])
    @bands = @q.result.includes(:users, :relationships).distinct(:true).kaminari_page(params[:page])
  end

  def new
    @band = Band.new
    @band.relationships.build
    @collections = User.pluck(:name, :id).unshift(['募集中', 0])
  end

  def create
    @band = Band.new(band_params)
       if validate_create(band_params)
      if @band.save
       redirect_to @band
       flash[:notice] = 'バンドの登録に成功しました'
      else
        flash[:alert] = 'バンドの登録に失敗しました'
        redirect_to new_band_path
      end
        else
         flash[:alert] = '作成者は必ずバンドに所属してください'
           redirect_to new_band_path
       end
  end

  def edit
    @band = Band.find(params[:id])
    @members = @band.users
    are_you_member?
    @collections = User.pluck(:name, :id).unshift(['募集中', 0])
  end

  def update
    @band = Band.find(params[:id])
    update_permission
    if @band.save
      create_notification_invitation
      if @band.users.any?
        redirect_to @band
        flash[:notice] = 'バンド情報の編集に成功しました'
      else
        @band.delete
        redirect_to @band
        flash[:alert] = 'メンバー不在のためバンドを削除しました'
      end
    else
      redirect_to edit_band_path
      flash[:alert] = 'バンド情報の編集に失敗しました'
    end
  end

  def show
    @band = Band.find(params[:id])
    @members = Relationship.where(band_id: @band.id)
    @users = @band.users
    unless @band.users.any?
      @band.delete
      redirect_to @band
      flash[:alert] = '何らかの理由によりメンバーが不在になったためバンドを削除しました'
    end
  end

  def destroy
    @band = Band.find(params[:id])
    @members = @band.users
    are_you_member?
    if @band.delete
      redirect_to bands_path
      flash[:notice] = '削除に成功しました'
    else
      flash[:alert] = '削除に失敗しました'
      render @band
    end
  end

  def are_you_member?
    unless  @members.any?{|v| v.id.to_i == current_user.id} && Relationship.where(user_id: current_user.id, band_id:@band.id)
      redirect_to root_path
      flash[:alert] = '権限がありません'
    end
  end

  def validate_create(relations)
    relations.to_unsafe_h[:relationships_attributes].any?{|k,v| v["user_id"].to_i == current_user.id}
  end

  #updateアクション時にband_paramsのpermissionを操作
  def update_permission
    beta_band_params = band_params[:relationships_attributes].each do |k,v|
      if v['user_id'].to_i == current_user.id
        v['permission'] = true
      end
      if Relationship.find_by(user_id: v['user_id'].to_i, band_id: @band.id)
        if Relationship.find_by(user_id: v['user_id'].to_i, band_id: @band.id).permission == true
          v['permission'] = true
        end
      end
    end
    new_band_params = {name: band_params[:name],relationships_attributes: beta_band_params.to_unsafe_h}
    @band.update(new_band_params)
  end

  def create_notification_invitation
    band_params[:relationships_attributes].each do |k,v|
      #削除には処理を外す
      unless v['_destroy'] == '1'
        #user_id募集中に通知を送らない
        unless v['user_id'] == '0'
          # すでに「いいね」されているか検索
          temp = Notification.where(["visitor_id = ? and visited_id = ? and band_id = ? and action = ? ",
                                     current_user.id, v['user_id'].to_i,
                                     @band.id, 'invitation'])
          # いいねされていない場合のみ、通知レコードを作成
          if temp.blank?
            notification = current_user.active_notifications.new(
                band_id: @band.id,
                visited_id: v['user_id'].to_i,
                action: 'invitation'
            )
            # 自分の投稿に対するいいねの場合は、通知済みとする
            if notification.visitor_id == notification.visited_id
              notification.checked = true
            end
            notification.save if notification.valid?
          end
        end
      end
    end
  end

private

  def band_params
    params.require(:band).permit(
      :name,
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
