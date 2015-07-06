class AddUserIdToLists < ActiveRecord::Migration
  def change
    add_column :fat_free_crm_lists, :user_id, :integer, default: nil
    add_index :fat_free_crm_lists, :user_id
  end
end
