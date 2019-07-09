# == Schema Information
#
# Table name: quiz_questions
#
#  id             :integer          not null, primary key
#  question       :text(65535)
#  choice_1       :string(255)
#  choice_2       :string(255)
#  choice_3       :string(255)
#  choice_4       :string(255)
#  correct_choice :string(255)
#  quiz_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class QuizQuestion < ApplicationRecord
  belongs_to :quiz
  has_many :quiz_question_attempts

  validates :question, :choice_1, :choice_2, :choice_3, :choice_4, :correct_choice, :quiz_id, presence: true
end
