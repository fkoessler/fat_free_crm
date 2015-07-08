class CreateFatFreeCRMGroups < ActiveRecord::Migration
  def change
    create_table :fat_free_crm_groups do |t|
      t.string :name
      t.timestamps
    end

    add_column :fat_free_crm_permissions, :group_id, :integer
    add_index :fat_free_crm_permissions, :group_id

    create_table :fat_free_crm_groups_users, id: false do |t|
      t.references :group
      t.references :user
    end
    add_index :fat_free_crm_groups_users, :group_id
    add_index :fat_free_crm_groups_users, :user_id
    add_index :fat_free_crm_groups_users, [:group_id, :user_id]
  end
end
