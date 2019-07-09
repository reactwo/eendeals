class CreateConversions < ActiveRecord::Migration[5.1]
  def change
    create_table :conversions do |t|
      t.string :transaction_id
      t.string :company
      t.string :company_id
      t.belongs_to :offer, foreign_key: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
