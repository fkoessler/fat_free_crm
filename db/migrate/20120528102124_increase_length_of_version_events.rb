class IncreaseLengthOfVersionEvents < ActiveRecord::Migration
  def up
    change_column :fat_free_crm_versions, :event, :string, limit: 512
  end

  def down
    change_column :fat_free_crm_versions, :event, :string, limit: 255
  end
end
