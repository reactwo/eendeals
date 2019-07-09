class AddMlmToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :refer_id, :string, null: true
    add_column :users, :sponsor_id, :string
    add_column :users, :real_sponsor_id, :string

    add_index :users, :refer_id, unique: true
  end
end
