class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :image
      t.decimal :price
      t.text :description
      t.string :link

      t.timestamps
    end
  end
end
