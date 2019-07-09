class AddNameToYouTube < ActiveRecord::Migration[5.1]
  def change
    add_column :you_tubes, :name, :string
  end
end
