class CrateNotification < ActiveRecord::Migration[6.0]
  def change
    def change
      create_table :notifications do |t|
        t.integer :visitor_id
        t.integer :visited_id
        t.integer :band_id
        t.string :action
        t.boolean :checked

        t.timestamps
      end
    end
  end
end
