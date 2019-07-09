# == Schema Information
#
# Table name: quiz_question_attempts
#
#  id               :integer          not null, primary key
#  quiz_attempt_id  :integer
#  quiz_question_id :integer
#  selected_choice  :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  time_taken       :decimal(8, 2)    default(0.0)
#

class QuizQuestionAttempt < ApplicationRecord
  belongs_to :quiz_attempt
  belongs_to :quiz_question

  validates :quiz_attempt_id, :quiz_question_id, presence: true
end
