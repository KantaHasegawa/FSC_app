# frozen_string_literal: true

class AddPermissionToRelationships < ActiveRecord::Migration[6.0]
  def change
    add_column :relationships, :permission, :boolean, default: false
  end
end
