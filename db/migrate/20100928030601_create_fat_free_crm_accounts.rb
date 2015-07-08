class CreateFatFreeCRMAccounts < ActiveRecord::Migration
  def self.up
    create_table :fat_free_crm_accounts, force: true do |t|
      t.string :uuid, limit: 36
      t.references :user
      t.integer :assigned_to
      t.string :name, limit: 64, null: false, default: ""
      t.string :access, limit: 8, default: "Public" # %w(Private Public Shared)
      t.string :website, limit: 64
      t.string :toll_free_phone, limit: 32
      t.string :phone, limit: 32
      t.string :fax, limit: 32
      t.string :billing_address
      t.string :shipping_address
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :fat_free_crm_accounts, [:user_id, :name, :deleted_at], unique: true
    add_index :fat_free_crm_accounts, :assigned_to
  end

  def self.down
    drop_table :fat_free_crm_accounts
  end
end
