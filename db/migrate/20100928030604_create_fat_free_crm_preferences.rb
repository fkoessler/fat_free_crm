class CreateFatFreeCRMPreferences < ActiveRecord::Migration
  def self.up
    create_table :fat_free_crm_preferences do |t|
      t.references :user
      t.string :name, limit: 32, null: false, default: ""
      t.text :value
      t.timestamps
    end
    add_index :fat_free_crm_preferences, [:user_id, :name]
  end

  def self.down
    drop_table :fat_free_crm_preferences
  end
end
