class AddRatingAndCategoryToFatFreeCRMAccounts < ActiveRecord::Migration
  def self.up
    add_column :fat_free_crm_accounts, :rating, :integer, default: 0, null: false
    add_column :fat_free_crm_accounts, :category, :string, limit: 32
  end

  def self.down
    remove_column :fat_free_crm_accounts, :category
    remove_column :fat_free_crm_accounts, :rating
  end
end
