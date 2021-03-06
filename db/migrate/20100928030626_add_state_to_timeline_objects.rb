class AddStateToTimelineObjects < ActiveRecord::Migration
  def self.up
    add_column :fat_free_crm_comments, :state, :string, limit: 16, null: false, default: "Expanded"
    add_column :fat_free_crm_emails,   :state, :string, limit: 16, null: false, default: "Expanded"
    execute("UPDATE fat_free_crm_comments SET state='Expanded'")
    execute("UPDATE fat_free_crm_emails   SET state='Expanded'")
  end

  def self.down
    remove_column :fat_free_crm_comments, :state
    remove_column :fat_free_crm_emails,   :state
  end
end
