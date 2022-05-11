class RemoveAvatarFromCustomers < ActiveRecord::Migration[6.1]
  def change
    remove_column :customers, :avatar, :string
  end
end
