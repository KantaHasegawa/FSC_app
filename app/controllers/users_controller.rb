class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    @q = User.paginate(page: params[:page]).ransack(params[:q])
    @users = @q.result(distinct: true)
  end

  def show
    @user = User.find(params[:id])
  end
end
