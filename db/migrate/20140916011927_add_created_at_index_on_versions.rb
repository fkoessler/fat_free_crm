class AddCreatedAtIndexOnVersions < ActiveRecord::Migration
  def change
    add_index :fat_free_crm_versions, :created_at
  end
end
