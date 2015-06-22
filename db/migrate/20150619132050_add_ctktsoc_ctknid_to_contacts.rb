class AddCtktsocCtknidToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :ctktsoc, :string, limit: 8
    add_column :contacts, :ctknid, :string, limit: 8
  end
end
