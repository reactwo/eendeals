class AddKindToRedeem < ActiveRecord::Migration[5.1]
  def change
    add_column :redeems, :kind, :integer
  end
end
