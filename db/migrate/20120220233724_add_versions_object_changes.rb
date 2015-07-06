class AddVersionsObjectChanges < ActiveRecord::Migration
  def up
    add_column :fat_free_crm_versions, :object_changes, :text
  end

  def down
    remove_column :fat_free_crm_versions, :object_changes
  end
end
