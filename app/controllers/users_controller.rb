class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).kaminari_page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @q = @user.bands.ransack(params[:q])
    @bands = @q.result.includes(:users, :relationships).kaminari_page(params[:page]).distinct(:true)
    @graduate_day = Date.new(@user.participated_at + 2,10)
    @today = Date.today
  end

  private

  #本人確認
  def who_are_you?
    unless current_user.id == params[:id].to_i
      redirect_to root_path
      flash[:alert] = '権限がありません'
    end
  end

end
