class RenameQuitUserIdColumnToNotifications < ActiveRecord::Migration[6.0]
  def change
    rename_column :notifications, :quit_user_id, :optional_id
  end
end
