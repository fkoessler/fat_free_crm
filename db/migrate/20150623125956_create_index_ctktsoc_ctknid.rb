class CreateIndexCtktsocCtknid < ActiveRecord::Migration
  def change
    add_index :contacts, [:ctktsoc, :ctknid]
    end
end
