class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.decimal :amount, precision: 10, scale: 4
      t.integer :category
      t.integer :direction
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
