class AddGameToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :game, :boolean, default: false
    add_column :users, :game_last, :date, default: 'NOW()'
  end
end
