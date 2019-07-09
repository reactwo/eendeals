# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  image       :string(255)
#  price       :decimal(10, )
#  description :text(65535)
#  link        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  active      :boolean          default(FALSE)
#  slug        :string(255)
#  amount      :decimal(10, 4)
#

class Product < ApplicationRecord

  validates :name, :image, :price, :description, :link, presence: true

  mount_uploader :image, OfferImageUploader

end
