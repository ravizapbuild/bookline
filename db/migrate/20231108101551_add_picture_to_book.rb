class AddPictureToBook < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :picture, :string
  end
end
