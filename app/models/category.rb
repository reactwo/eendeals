# == Schema Information
#
# Table name: categories
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  image           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  banner_id       :string(255)
#  interstitial_id :string(255)
#  rewarded_id     :string(255)
#  task_id         :integer
#

class Category < ApplicationRecord

  mount_uploader :image, OfferImageUploader

  has_many :wallpapers
  belongs_to :task

  validates :name, :image, :banner_id, :interstitial_id, :rewarded_id, presence: true

end
