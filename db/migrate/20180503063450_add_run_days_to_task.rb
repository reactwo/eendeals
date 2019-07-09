class AddRunDaysToTask < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :run_days, :integer, default: 1
  end
end
