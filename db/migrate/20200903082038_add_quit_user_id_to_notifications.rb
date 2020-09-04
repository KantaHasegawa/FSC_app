# frozen_string_literal: true

class AddQuitUserIdToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :quit_user_id, :integer, null: true
  end
end
