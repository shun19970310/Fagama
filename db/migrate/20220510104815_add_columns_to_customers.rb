class AddColumnsToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :introduction, :text
    add_column :customers, :avatar, :string
    add_column :customers, :is_deleted, :boolean, default: false
  end
end
