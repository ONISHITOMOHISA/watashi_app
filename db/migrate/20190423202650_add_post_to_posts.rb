class AddPostToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :object, :string
  end
end
