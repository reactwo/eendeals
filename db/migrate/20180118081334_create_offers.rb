class CreateOffers < ActiveRecord::Migration[5.1]
  def change
    create_table :offers do |t|
      t.integer :company_id
      t.integer :downloaded, default: 0
      t.string :link
      t.string :logo
      t.string :name
      t.text :instructions
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
