class CreateDealItem < ActiveRecord::Migration
  def up
    create_table :deal_items, id: false do |t|
      t.uuid :id, primary_key: true
      t.column :quantity, :integer
      t.uuid :product_id
      t.uuid :deal_id
    end
    add_index :deal_items, :id
    add_index :deal_items, :deal_id
  end

  def down
    remove_index :deal_items, :column => :deal_id
    remove_index :deal_items, :column => :id
    drop_table :deal_items
  end
end
