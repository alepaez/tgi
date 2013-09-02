class CreateDeal < ActiveRecord::Migration
  def up
    create_table :deals, id: false do |t|
      t.uuid :id, primary_key: true
      t.column :status, :string
      t.uuid :contact_id
      t.timestamps
    end
    add_index :deals, :id
  end

  def down
    remove_index :deals, :column => :id
    drop_table :deals
  end
end
