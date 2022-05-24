class AddImageToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :image, :string
  end
end
