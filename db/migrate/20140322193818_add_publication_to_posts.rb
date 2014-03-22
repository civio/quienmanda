class AddPublicationToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :published_at, :datetime, null: true

    execute <<-SQL
      update posts set published_at = updated_at
    SQL
  end
end
