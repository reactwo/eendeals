class AddCapToTask < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :cap, :integer, default: 0
  end
end
