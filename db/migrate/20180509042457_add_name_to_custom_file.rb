class AddNameToCustomFile < ActiveRecord::Migration[5.1]
  def change
    add_column :custom_files, :name, :string
  end
end
