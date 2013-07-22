class CreateProduct < ActiveRecord::Migration
  def up
    create_table :products, id: false do |t|
      t.uuid :id, primary_key: true
      t.column :description, :string
      t.column :status, :string
      t.column :price_cents, :int
      t.uuid :account_id
    end
    add_index :products, :id
  end

  def down
    remove_index :products, :column => :id
    drop_table :products
  end
end
