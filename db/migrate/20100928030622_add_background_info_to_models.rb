class AddBackgroundInfoToModels < ActiveRecord::Migration
  def self.up
    add_column :fat_free_crm_accounts, :background_info, :string
    add_column :fat_free_crm_campaigns, :background_info, :string
    add_column :fat_free_crm_contacts, :background_info, :string
    add_column :fat_free_crm_leads, :background_info, :string
    add_column :fat_free_crm_opportunities, :background_info, :string
    add_column :fat_free_crm_tasks, :background_info, :string
  end

  def self.down
    remove_column :fat_free_crm_accounts, :background_info
    remove_column :fat_free_crm_campaigns, :background_info
    remove_column :fat_free_crm_contacts, :background_info
    remove_column :fat_free_crm_leads, :background_info
    remove_column :fat_free_crm_opportunities, :background_info
    remove_column :fat_free_crm_tasks, :background_info
  end
end
