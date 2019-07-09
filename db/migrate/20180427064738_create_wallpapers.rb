class CreateWallpapers < ActiveRecord::Migration[5.1]
  def change
    create_table :wallpapers do |t|
      t.string :name
      t.string :image
      t.integer :downloaded, default: 0
      t.boolean :premium, default: false
      t.belongs_to :category, foreign_key: true

      t.timestamps
    end
  end
end
