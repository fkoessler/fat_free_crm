class CreateFatFreeCRMLists < ActiveRecord::Migration
  def change
    create_table :fat_free_crm_lists do |t|
      t.string :name
      t.text :url

      t.timestamps
    end
  end
end
