class AddGroupImageIdToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :group_image_id, :string
  end
end
