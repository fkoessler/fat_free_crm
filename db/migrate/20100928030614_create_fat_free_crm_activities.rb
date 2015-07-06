class CreateFatFreeCRMActivities < ActiveRecord::Migration
  def self.up
    create_table :fat_free_crm_activities, force: true do |t|
      t.references :user                                           # User who's activity gets recorded.
      t.references :subject, polymorphic: true                  # Points to related asset (account, contact, etc.).
      t.string :action,  limit: 32, default: "created"   # Action taken: created, updated, deleted.
      t.string :info,    default: ""                        # Extra information related to the asset and the action.
      t.boolean :private, default: false                     # True if the action shouldn't be shared with others.
      t.timestamps
    end

    add_index :fat_free_crm_activities, :user_id
    add_index :fat_free_crm_activities, :created_at
  end

  def self.down
    drop_table :fat_free_crm_activities
  end
end
