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

class Limit < ApplicationRecord
  has_soft_delete validate: false
  belongs_to :user
  belongs_to :old_user, required: false
end
