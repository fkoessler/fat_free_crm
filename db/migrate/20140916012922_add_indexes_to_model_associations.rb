class AddIndexesToModelAssociations < ActiveRecord::Migration
  def change
    add_index :fat_free_crm_contact_opportunities, [:contact_id, :opportunity_id], name: 'idx_ffcrm_ctct_opprtnties_on_ctct_id_and_opprtnty_id'
    add_index :fat_free_crm_account_opportunities, [:account_id, :opportunity_id], name: 'idx_ffcrm_accnt_opprtnties_on_accnt_id_and_opprtnty_id'
  end
end
