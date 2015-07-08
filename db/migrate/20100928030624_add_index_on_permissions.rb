class AddIndexOnPermissions < ActiveRecord::Migration
  def self.up
    add_index :fat_free_crm_permissions, [:asset_id, :asset_type]
  end

  def self.down
    remove_index :fat_free_crm_permissions, [:asset_id, :asset_type]
  end
end
