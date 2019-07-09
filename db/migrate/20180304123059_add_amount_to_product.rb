class AddAmountToProduct < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :amount, :decimal, scale: 4, precision: 10
  end
end
