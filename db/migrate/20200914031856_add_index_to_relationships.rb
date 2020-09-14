class AddIndexToRelationships < ActiveRecord::Migration[6.0]
  def change
    add_index :relationships, :user_id
    add_index :relationships, :band_id
    add_index :notifications, :visitor_id
    add_index :notifications, :visited_id
    add_index :notifications, :band_id
  end
end
