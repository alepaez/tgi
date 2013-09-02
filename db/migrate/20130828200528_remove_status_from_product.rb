class RemoveStatusFromProduct < ActiveRecord::Migration
  def up
    remove_column :products, :status
  end

  def down
    add_column :products, :status, :string
  end
end
