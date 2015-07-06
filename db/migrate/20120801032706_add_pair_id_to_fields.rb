class AddPairIdToFields < ActiveRecord::Migration
  def change
    add_column :fat_free_crm_fields, :pair_id, :integer
  end
end
