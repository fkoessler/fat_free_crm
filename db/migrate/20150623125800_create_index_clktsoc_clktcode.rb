class CreateIndexClktsocClktcode < ActiveRecord::Migration
  def change
    add_index :fat_free_crm_accounts, [:clktsoc, :clktcode]
  end
end
