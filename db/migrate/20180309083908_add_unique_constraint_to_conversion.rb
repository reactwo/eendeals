class AddUniqueConstraintToConversion < ActiveRecord::Migration[5.1]
  def change
    add_index :conversions, :transaction_id, unique: true
  end
end
