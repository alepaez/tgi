class CreateAddress < ActiveRecord::Migration
  def up
    create_table :addresses, id: false do |t|
      t.uuid :id, primary_key: true
      t.column :description, :string
      t.column :country, :string
      t.column :state, :string
      t.column :city, :string
      t.column :address, :string
      t.column :number, :string
      t.column :complement, :string
      t.uuid :contact_id
      t.timestamps
    end
    add_index :addresses, :id
  end

  def down
    remove_index :addresses, :column => :id
    drop_table :addresses
  end
end
