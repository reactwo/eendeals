# == Schema Information
#
# Table name: quiz_attempts
#
#  id          :integer          not null, primary key
#  quiz_id     :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  status      :integer          default(1)
#  points      :decimal(10, 4)
#  deleted_at  :datetime
#  old_user_id :integer
#

class QuizAttempt < ApplicationRecord
  has_soft_delete validate: false
  belongs_to :quiz
  belongs_to :user
  belongs_to :old_user, required: false
  has_many :quiz_question_attempts, dependent: :destroy

  validates :quiz_id, :user_id, presence: true

  STATUS = {
      incomplete: 1,
      complete: 2
  }

  STATUS_REVERSE = {
      1 => 'Incomplete',
      2 => 'Complete'
  }
end
