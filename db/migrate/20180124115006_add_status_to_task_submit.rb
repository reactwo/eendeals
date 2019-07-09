class AddStatusToTaskSubmit < ActiveRecord::Migration[5.1]
  def change
    add_column :task_submits, :status, :integer, default: 1
  end
end
