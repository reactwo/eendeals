# == Schema Information
#
# Table name: limits
#
#  id          :integer          not null, primary key
#  video1      :integer
#  video2      :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  deleted_at  :datetime
#  old_user_id :integer
#

class LimitSerializer < ActiveModel::Serializer
  attributes :id, :video1, :video2
end
