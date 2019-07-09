# == Schema Information
#
# Table name: task_submits
#
#  id          :integer          not null, primary key
#  task_id     :integer
#  user_id     :integer
#  image       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  status      :integer          default(1)
#  deleted_at  :datetime
#  old_user_id :integer
#

class TaskSubmit < ApplicationRecord
  has_soft_delete validate: false
  belongs_to :task
  belongs_to :user
  belongs_to :old_user, required: false

  mount_base64_uploader :image, TaskSubmissionUploader

  STATUS = {
      unapproved: 1,
      approved: 2
  }

  STATUS_REVERSE = {
      1 => 'Unapproved',
      2 => 'Approved'
  }
end
