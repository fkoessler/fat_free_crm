class CreateIndexCtktsocCtknid < ActiveRecord::Migration
  def change
    add_index :fat_free_crm_contacts, [:ctktsoc, :ctknid]
    end
end
