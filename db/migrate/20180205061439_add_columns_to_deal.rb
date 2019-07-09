class AddColumnsToDeal < ActiveRecord::Migration[5.1]
  def change
    add_column :deals, :cap, :integer, default: 0
    add_column :deals, :reward_later, :boolean, default: false
  end
end
