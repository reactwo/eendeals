# == Schema Information
#
# Table name: quiz_winners
#
#  id          :integer          not null, primary key
#  quiz_id     :integer
#  user_id     :integer
#  points      :decimal(10, 4)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  position    :integer
#  deleted_at  :datetime
#  old_user_id :integer
#

class QuizWinner < ApplicationRecord
  has_soft_delete validate: false
  belongs_to :quiz
  belongs_to :user
  belongs_to :old_user, required: false

  validates :quiz_id, :user_id, :points, :position, presence: true
end
