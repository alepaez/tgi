class CreatePhone < ActiveRecord::Migration
  def up
    create_table :phones, id: false do |t|
      t.uuid :id, primary_key: true
      t.column :description, :string
      t.column :number, :string
      t.uuid :contact_id
      t.timestamps
    end
    add_index :phones, :id
  end

  def down
    remove_index :phones, :column => :id
    drop_table :phones
  end
end
