class ChangeFieldsCollectionToText < ActiveRecord::Migration
  def self.up
    change_column :fat_free_crm_fields, :collection, :text
  end

  def self.down
    change_column :fat_free_crm_fields, :collection, :string
  end
end
