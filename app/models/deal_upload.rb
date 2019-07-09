# == Schema Information
#
# Table name: deal_uploads
#
#  id          :integer          not null, primary key
#  image       :string(255)
#  deal_id     :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  status      :boolean          default(FALSE)
#  deleted_at  :datetime
#  old_user_id :integer
#

class DealUpload < ApplicationRecord
  has_soft_delete validate: false
  validates :image, :deal_id, :user_id, presence: true

  belongs_to :deal
  belongs_to :user
  belongs_to :old_user, required: false

  mount_base64_uploader :image, TaskSubmissionUploader
end
