class CreateContact < ActiveRecord::Migration
  def up
    create_table :contacts, id: false do |t|
      t.uuid :id, primary_key: true
      t.column :name, :string
      t.column :email, :string
      t.uuid :account_id
      t.timestamps
    end
    add_index :contacts, :id
  end

  def down
    remove_index :contacts, column: :id
    drop_table :contacts
  end
end
