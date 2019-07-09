class AddSoftDeleteToTaskSubmit < ActiveRecord::Migration[5.1]
  def change
    add_column :task_submits, :deleted_at, :datetime
    add_reference :task_submits, :old_user, foreign_key: true
  end
end
