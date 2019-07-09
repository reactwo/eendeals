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

class QuizWinnerSerializer < ActiveModel::Serializer
  attributes :id, :date, :user, :position

  def date
    object.quiz.date
  end

  def user
    JSON.parse(UserSerializer.new(object.user).to_json).except('authentication_token')
  end
end
