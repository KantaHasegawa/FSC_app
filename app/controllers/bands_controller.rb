class BandsController < ApplicationController
  before_action :authenticate_user!
  def index
    @q = Band.paginate(page: params[:page]).ransack(params[:q])
    @collections = User.pluck(:name, :id).unshift(['募集中', 0])
    @bands = @q.result.includes(:users, :relationships).distinct(:true)
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
    @band.update(band_params)
    if @band.save
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
    @members = @band.users
    @offerings = Relationship.where(user_id: 0, band_id: @band.id)
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

  # privateメソッド
  private

  def are_you_member?
    unless  @members.any?{|v| v.id.to_i == current_user.id}
      redirect_to root_path
      flash[:alert] = '権限がありません'
    end
  end

  def validate_create(relations)
    relations.to_unsafe_h[:relationships_attributes].any?{|k,v| v["user_id"].to_i == current_user.id}
  end



  def band_params
    params.require(:band).permit(
      :name,
      relationships_attributes: %i[
        id
        part
        band_id
        user_id
        _destroy
      ]
    )
  end
end
