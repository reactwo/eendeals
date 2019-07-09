# == Schema Information
#
# Table name: wallpapers
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  image       :string(255)
#  downloaded  :integer          default(0)
#  premium     :boolean          default(FALSE)
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Wallpaper < ApplicationRecord

  mount_uploader :image, OfferImageUploader

  belongs_to :category

  validates :name, :image, :downloaded, :premium, :category_id, presence: true
end
