class DeleteOptionalIdAndDestroyBandToNotifications < ActiveRecord::Migration[6.0]
  change_table :notifications do |t|
    t.remove :optional_id, :destroy_band
  end
end
