class AddImageIdToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :image_id, :string
  end
end
