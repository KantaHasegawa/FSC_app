class ChangeToRelatioinship < ActiveRecord::Migration[6.0]
  def up
    change_column_null :relationships, :user_id, false, 0
    change_column :relationships, :user_id, :integer, default: 0
  end

  def down
    change_column_null :relationships, :user_id, true, nil
    change_column :relationships, :user_id, :integer, default: nil
  end
end
