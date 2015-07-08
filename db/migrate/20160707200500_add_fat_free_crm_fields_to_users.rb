class AddFatFreeCRMFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, null: false, default: "", limit: 32
    add_column :users, :first_name, :string, limit: 32
    add_column :users, :last_name, :string, limit: 32
    add_column :users, :title, :string, limit: 64
    add_column :users, :company, :string, limit: 64
    add_column :users, :alt_email, :string, limit: 254
    add_column :users, :phone, :string, limit: 32
    add_column :users, :mobile, :string, limit: 32
    add_column :users, :aim, :string, limit: 32
    add_column :users, :yahoo, :string, limit: 32
    add_column :users, :google, :string, limit: 32
    add_column :users, :skype, :string, limit: 32
    add_column :users, :deleted_at, :datetime
    add_column :users, :suspended_at, :datetime

    add_index :users, [:username, :deleted_at], unique: true
  end
end
