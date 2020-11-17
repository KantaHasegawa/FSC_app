class DeleteDestroyCheckToRelationships < ActiveRecord::Migration[6.0]
  change_table :relationships do |t|
    t.remove :destroy_check
  end
end
