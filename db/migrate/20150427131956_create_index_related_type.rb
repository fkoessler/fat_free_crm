class CreateIndexRelatedType < ActiveRecord::Migration
  def up
    add_index :fat_free_crm_versions, [:related_id, :related_type]
  end

  def down
    remove_index :fat_free_crm_versions, [:related_id, :related_type]
  end
end
