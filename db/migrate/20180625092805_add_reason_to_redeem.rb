class AddReasonToRedeem < ActiveRecord::Migration[5.1]
  def change
    add_column :redeems, :reason, :string
  end
end
