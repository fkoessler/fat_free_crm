class CreateFatFreeCRMLeads < ActiveRecord::Migration
  def self.up
    create_table :fat_free_crm_leads, force: true do |t|
      t.string :uuid,   limit: 36
      t.references :user
      t.references :campaign
      t.integer :assigned_to
      t.string :first_name,  limit: 64, null: false, default: ""
      t.string :last_name,   limit: 64, null: false, default: ""
      t.string :access,      limit: 8, default: "Public"
      t.string :title,       limit: 64
      t.string :company,     limit: 64
      t.string :source,      limit: 32
      t.string :status,      limit: 32
      t.string :referred_by, limit: 64
      t.string :email,       limit: 64
      t.string :alt_email,   limit: 64
      t.string :phone,       limit: 32
      t.string :mobile,      limit: 32
      t.string :blog,        limit: 128
      t.string :linkedin,    limit: 128
      t.string :facebook,    limit: 128
      t.string :twitter,     limit: 128
      t.string :address
      t.integer :rating,      null: false, default: 0
      t.boolean :do_not_call, null: false, default: false
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :fat_free_crm_leads, [:user_id, :last_name, :deleted_at], unique: true, name: 'index_ffcrm_leads_on_user_id_and_last_name_and_deleted_at'
    add_index :fat_free_crm_leads, :assigned_to
  end

  def self.down
    drop_table :fat_free_crm_leads
  end
end
