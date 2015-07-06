class AddSkypeToContactsAndLeads < ActiveRecord::Migration
  def self.up
    add_column :fat_free_crm_contacts, :skype, :string, limit: 128
    add_column :fat_free_crm_leads, :skype, :string, limit: 128
  end

  def self.down
    remove_column :fat_free_crm_contacts, :skype
    remove_column :fat_free_crm_leads, :skype
  end
end
