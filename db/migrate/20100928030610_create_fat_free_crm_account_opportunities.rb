class CreateFatFreeCRMAccountOpportunities < ActiveRecord::Migration
  def self.up
    create_table :fat_free_crm_account_opportunities, force: true do |t|
      t.references :account
      t.references :opportunity
      t.datetime :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :fat_free_crm_account_opportunities
  end
end
