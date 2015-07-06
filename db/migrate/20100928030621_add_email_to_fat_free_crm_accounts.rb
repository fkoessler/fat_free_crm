class AddEmailToFatFreeCRMAccounts < ActiveRecord::Migration
  def self.up
    add_column :fat_free_crm_accounts, :email, :string, limit: 64
  end

  def self.down
    remove_column :fat_free_crm_accounts, :email
  end
end
