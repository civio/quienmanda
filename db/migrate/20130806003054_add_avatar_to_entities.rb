class AddAvatarToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :avatar, :string
  end
end
