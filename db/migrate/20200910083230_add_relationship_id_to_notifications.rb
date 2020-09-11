class AddRelationshipIdToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :relationship_id, :integer
  end
end
