class AddLockToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :lock, :boolean, default: false
    add_column :users, :lock_last, :date, default: 'NOW()'
  end
end
