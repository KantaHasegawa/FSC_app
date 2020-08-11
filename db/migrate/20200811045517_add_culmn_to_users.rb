class AddCulmnToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string
    add_column :users, :gender, :integer
    add_column :users, :generation, :integer
  end
end
