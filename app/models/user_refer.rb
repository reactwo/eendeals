# == Schema Information
#
# Table name: user_refers
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  down_user_id :integer
#  level        :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class UserRefer < ApplicationRecord
  belongs_to :user
  belongs_to :down_user, class_name: 'User'
end
