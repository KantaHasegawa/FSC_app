class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    @q = User.paginate(page: params[:page]).ransack(params[:q])
    @users = @q.result(distinct: true)
  end

  def show
    @user = User.find(params[:id])
    params[:q][:relationships_user_id_eq] = @user.id if params[:q]
    @q = Band.paginate(page: params[:page]).ransack(params[:q])
    @bands = @q.result.includes(:users, :relationships).distinct(:true)
  end
end
