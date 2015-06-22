class AddClktsocClktcodeToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :clktsoc, :string, limit: 8
    add_column :accounts, :clktcode, :string, limit: 8
  end
end
