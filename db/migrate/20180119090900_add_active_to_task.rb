class AddActiveToTask < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :active, :boolean, default: false
  end
end
