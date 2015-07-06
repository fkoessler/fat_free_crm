class CreateFatFreeCRMContactOpportunities < ActiveRecord::Migration
  def self.up
    create_table :fat_free_crm_contact_opportunities, force: true do |t|
      t.references :contact
      t.references :opportunity
      t.string :role, limit: 32
      t.datetime :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :fat_free_crm_contact_opportunities
  end
end
