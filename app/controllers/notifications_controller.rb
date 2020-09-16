# frozen_string_literal: true

class NotificationsController < ApplicationController
  def index # 通知の表示
    @notifications = current_user.passive_notifications.kaminari_page(params[:page]).per(20)
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end
end
