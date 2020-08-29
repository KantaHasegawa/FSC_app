class AddCulmnToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string
    add_column :users, :gender, :integer
    add_column :users, :participated_at, :integer
    add_column :users, :roll, :string
    add_column :users, :main_part, :string
    add_column :users, :active_admin, :integer, default: 0
  end
end
