class CreateFatFreeCRMComments < ActiveRecord::Migration
  def self.up
    create_table :fat_free_crm_comments, force: true do |t|
      t.references :user
      t.references :commentable, polymorphic: true
      t.boolean :private  # TODO: add support for private comments.
      t.string :title,   default: ""
      t.text :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :fat_free_crm_comments
  end
end
