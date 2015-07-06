class CreateFatFreeCRMFields < ActiveRecord::Migration
  def self.up
    create_table :fat_free_crm_fields, force: true do |t|
      t.string :type
      t.references :field_group
      t.string :klass_name,  limit: 32
      t.integer :position
      t.string :name,        limit: 64
      t.string :label,       limit: 128
      t.string :hint
      t.string :placeholder
      t.string :as,          limit: 32
      t.string :collection
      t.boolean :disabled
      t.boolean :required
      t.integer :maxlength,   limit: 4
      t.timestamps
    end
    add_index :fat_free_crm_fields, :name
    add_index :fat_free_crm_fields, :klass_name
    add_index :fat_free_crm_fields, :field_group_id
  end

  def self.down
    drop_table :fat_free_crm_fields
  end
end
