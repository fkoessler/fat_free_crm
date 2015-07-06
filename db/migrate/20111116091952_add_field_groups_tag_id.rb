class AddFieldGroupsTagId < ActiveRecord::Migration
  def self.up
    add_column :fat_free_crm_field_groups, :tag_id, :integer
  end

  def self.down
    remove_column :fat_free_crm_field_groups, :tag_id
  end
end
