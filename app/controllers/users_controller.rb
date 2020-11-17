# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit]
  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).kaminari_page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @q = @user.bands.ransack(params[:q])
    @bands = @q.result.includes(:users, :relationships).kaminari_page(params[:page]).distinct(true)
  end

end
