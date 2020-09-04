# frozen_string_literal: true

class AddDestroyCheckToRelationships < ActiveRecord::Migration[6.0]
  def change
    add_column :relationships, :destroy_check, :boolean, default: false
  end
end
