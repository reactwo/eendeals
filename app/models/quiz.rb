# == Schema Information
#
# Table name: quizzes
#
#  id         :integer          not null, primary key
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Quiz < ApplicationRecord

  validates :date, presence: true

  has_many :quiz_questions
  has_many :quiz_attempts
  has_many :quiz_winners

end
