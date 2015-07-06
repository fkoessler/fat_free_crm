class RemoveDefaultValueAndClearSettings < ActiveRecord::Migration
  def up
    remove_column :fat_free_crm_settings, :default_value

    # Truncate settings table
    if connection.adapter_name.downcase == "sqlite"
      execute("DELETE FROM fat_free_crm_settings")
    else # mysql and postgres
      execute("TRUNCATE fat_free_crm_settings")
    end
  end

  def down
    add_column :fat_free_crm_settings, :default_value, :text
  end
end
