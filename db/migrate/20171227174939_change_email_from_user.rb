class ChangeEmailFromUser < ActiveRecord::Migration[5.1]
  def up
    change_column :users, :email, :string, null: true, default: ''
    remove_index :users, :email
  end

  def down
    change_column :users, :email, :string, null: false, default: ''
    add_index :users, :email, unique: true
  end
end
