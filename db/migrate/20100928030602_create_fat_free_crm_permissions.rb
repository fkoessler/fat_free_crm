class CreateFatFreeCRMPermissions < ActiveRecord::Migration
  def self.up
    create_table :fat_free_crm_permissions, force: true do |t|
      t.references :user                          # User who is allowed to access the asset.
      t.references :asset, polymorphic: true   # Creates asset_id and asset_type.
      t.timestamps
    end

    add_index :fat_free_crm_permissions, :user_id
  end

  def self.down
    drop_table :fat_free_crm_permissions
  end
end
