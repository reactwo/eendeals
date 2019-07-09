class MakeRewardTasksUnique < ActiveRecord::Migration[5.1]
  def change
    add_index :reward_tasks, [:user_id, :task_id], unique: true
  end
end
