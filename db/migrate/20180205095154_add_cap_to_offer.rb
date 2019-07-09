class AddCapToOffer < ActiveRecord::Migration[5.1]
  def change
    add_column :offers, :cap, :integer, default: 0
  end
end
