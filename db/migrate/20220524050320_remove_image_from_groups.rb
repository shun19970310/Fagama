class RemoveImageFromGroups < ActiveRecord::Migration[6.1]
  def change
    remove_column :groups, :image, :string
  end
end
