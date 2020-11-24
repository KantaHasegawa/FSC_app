# frozen_string_literal: true

class BandsController < ApplicationController
  before_action :authenticate_user!
  def index
    @q = Band.ransack(params[:q])
    @collections = User.pluck(:name, :id).unshift(['募集中', 0])
    @bands = @q.result.includes(:users, :relationships).distinct(true).kaminari_page(params[:page])
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

  def new
    @band = Band.new

  end

  def create
    @band = Band.new(band_params)
    if @band.save
      @band.invitation_notification(band_params['relationships_attributes'], current_user)
      redirect_to @band
      flash[:notice] = 'バンドの登録に成功しました'
    else
      flash[:alert] = 'バンドの登録に失敗しました'
      render "new"
    end
  end

  def edit
    @band = Band.find(params[:id])
    are_you_member?(@band, current_user)

  end

  def update
    @band = Band.find(params[:id])
    @band.update(band_params)
    if @band.save
      redirect_to @band
      flash[:notice] = 'バンド情報の編集に成功しました'
    else
      render "edit"
      flash[:alert] = 'バンド情報の編集に失敗しました'
    end
  end


  def invitation
    @collections = User.pluck(:name, :id).unshift(['募集中', 0])
    @band = Band.find(params[:id])
    are_you_member?(@band, current_user)
    @band.users.each do |i|
      @collections.delete([i.name, i.id]) if i.id != 0
    end
  end

  def invitation_update
    @band = Band.find(params[:id])
    @band.update(band_params)
    @band.invitation_notification(band_params['relationships_attributes'], current_user)
    redirect_to @band
    flash[:notice] = '招待に成功しました'
  end

  def destroy_member
    @band = Band.find(params[:id])
    are_you_member?(@band, current_user)
    @members = @band.relationships
  end

  def destroy_member_delete
    @band = Band.find(params[:id])
    if params[:deletes].present?
      checked_data = params[:deletes].values # ここでcheckされたデータを受け取っています。
      Relationship.destroy(checked_data)
        if @band.users.empty?
          @band.destroy
          redirect_to @band
          flash[:notice] = 'メンバーが存在しないためバンドを削除しました'
        else
          redirect_to  @band
          flash[:notice] = 'メンバーの削除に成功しました'
        end
    else
      redirect_to destroy_member_band_path
      flash[:alert] = "削除するメンバーを選択してください"
    end


  end

  def destroy
    @band = Band.find(params[:id])
    @band.destroy
      redirect_to bands_path
      flash[:notice] = 'バンドの削除に成功しました'
  end

    def are_you_member?(band,current_user)
    unless Relationship.find_by(band_id: band.id, user_id: current_user.id, permission: true).present?
      redirect_to root_path
      flash[:alert] = '権限がありません'
    end
  end



  private

  def band_params
    params.require(:band).permit(
      :name,
      :image,
      :deletes,
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
