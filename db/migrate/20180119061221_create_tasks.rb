class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :instructions
      t.decimal :amount
      t.string :link

      t.timestamps
    end
  end
end
