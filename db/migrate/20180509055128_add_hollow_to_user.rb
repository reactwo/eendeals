class AddHollowToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :hollow, :boolean, default: false
  end
end
