class AddSuspendedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :suspended_at, :datetime
    rename_column :fat_free_crm_accounts, :tall_free_phone, :toll_free_phone
  end

  def self.down
    rename_column :fat_free_crm_accounts, :toll_free_phone, :tall_free_phone
    remove_column :users, :suspended_at
  end
end
