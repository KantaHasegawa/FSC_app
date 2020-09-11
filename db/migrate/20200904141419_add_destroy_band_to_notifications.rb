class AddDestroyBandToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :destroy_band, :string, null: true
  end
end
