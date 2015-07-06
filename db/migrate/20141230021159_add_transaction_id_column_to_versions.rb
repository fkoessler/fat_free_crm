class AddTransactionIdColumnToVersions < ActiveRecord::Migration
  def self.up
    add_column :fat_free_crm_versions, :transaction_id, :integer
    add_index :fat_free_crm_versions, [:transaction_id]
  end

  def self.down
    remove_index :fat_free_crm_versions, [:transaction_id]
    remove_column :fat_free_crm_versions, :transaction_id
  end
end
