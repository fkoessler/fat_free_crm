class AddCtktsocCtknidToContacts < ActiveRecord::Migration
  def change
    add_column :fat_free_crm_contacts, :ctktsoc, :string, limit: 8
    add_column :fat_free_crm_contacts, :ctknid, :string, limit: 8
  end
end
