# == Schema Information
#
# Table name: reward_tasks
#
#  id          :integer          not null, primary key
#  task_id     :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  deleted_at  :datetime
#  old_user_id :integer
#

class RewardTask < ApplicationRecord
  has_soft_delete validate: false
  belongs_to :task
  belongs_to :user
  belongs_to :old_user, required: false
end
