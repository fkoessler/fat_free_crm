class AddClktsocClktcodeToAccounts < ActiveRecord::Migration
  def change
    add_column :fat_free_crm_accounts, :clktsoc, :string, limit: 8
    add_column :fat_free_crm_accounts, :clktcode, :string, limit: 8
  end
end
