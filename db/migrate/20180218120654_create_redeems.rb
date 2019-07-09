class CreateRedeems < ActiveRecord::Migration[5.1]
  def change
    create_table :redeems do |t|
      t.string :mobile
      t.string :account_no
      t.string :ifsc
      t.string :bank_name
      t.string :name
      t.string :email
      t.decimal :coins, precision: 10, scale: 4
      t.belongs_to :user, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
