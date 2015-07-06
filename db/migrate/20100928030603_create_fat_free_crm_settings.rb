class CreateFatFreeCRMSettings < ActiveRecord::Migration
  def self.up
    create_table :fat_free_crm_settings, force: true do |t|
      t.string :name, limit: 32, null: false, default: ""
      t.text :value
      t.text :default_value
      t.timestamps
    end
    add_index :fat_free_crm_settings, :name
  end

  def self.down
    drop_table :fat_free_crm_settings
  end
end
