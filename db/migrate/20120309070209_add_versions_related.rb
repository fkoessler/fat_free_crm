class AddVersionsRelated < ActiveRecord::Migration
  def change
    add_column :fat_free_crm_versions, :related_id, :integer
    add_column :fat_free_crm_versions, :related_type, :string
  end
end
