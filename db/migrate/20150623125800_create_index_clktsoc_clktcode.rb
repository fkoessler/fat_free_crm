class CreateIndexClktsocClktcode < ActiveRecord::Migration
  def change
    add_index :accounts, [:clktsoc, :clktcode]
  end
end
