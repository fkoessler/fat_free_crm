class AddIndexOnVersionsItemType < ActiveRecord::Migration
  def change
    add_index :fat_free_crm_versions, :whodunnit
  end
end
