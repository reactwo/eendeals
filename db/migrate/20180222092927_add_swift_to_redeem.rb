class AddSwiftToRedeem < ActiveRecord::Migration[5.1]
  def change
    add_column :redeems, :swift_code, :string
  end
end
