class IncreaseEmailTo254Chars < ActiveRecord::Migration
  def up
    change_column :fat_free_crm_accounts, :email, :string, limit: 254
    change_column :fat_free_crm_contacts, :email, :string, limit: 254
    change_column :fat_free_crm_contacts, :alt_email, :string, limit: 254
    change_column :fat_free_crm_leads, :email, :string, limit: 254
    change_column :fat_free_crm_leads, :alt_email, :string, limit: 254
    change_column :users, :email, :string, limit: 254
    change_column :users, :alt_email, :string, limit: 254
  end

  def down
    change_column :fat_free_crm_accounts, :email, :string, limit: 64
    change_column :fat_free_crm_contacts, :email, :string, limit: 64
    change_column :fat_free_crm_contacts, :alt_email, :string, limit: 64
    change_column :fat_free_crm_leads, :email, :string, limit: 64
    change_column :fat_free_crm_leads, :alt_email, :string, limit: 64
    change_column :users, :email, :string, limit: 64
    change_column :users, :alt_email, :string, limit: 64
  end
end
