class AddSoftDeleteToRewardTask < ActiveRecord::Migration[5.1]
  def change
    add_column :reward_tasks, :deleted_at, :datetime
    add_reference :reward_tasks, :old_user, foreign_key: true
  end
end
