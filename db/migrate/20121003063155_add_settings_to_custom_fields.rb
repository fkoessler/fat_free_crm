class AddSettingsToCustomFields < ActiveRecord::Migration
  def change
    add_column :fat_free_crm_fields, :settings, :text, default: nil
  end
end
