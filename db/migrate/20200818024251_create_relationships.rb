# frozen_string_literal: true

class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships do |t|
      t.string :part
      t.integer :user_id
      t.integer :band_id

      t.timestamps
    end
  end
end
