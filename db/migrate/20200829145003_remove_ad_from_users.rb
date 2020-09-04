# frozen_string_literal: true

class RemoveAdFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :active_admin, :integer
  end
end
