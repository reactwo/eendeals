# == Schema Information
#
# Table name: offers
#
#  id           :integer          not null, primary key
#  company_id   :integer
#  downloaded   :integer          default(0)
#  link         :string(255)
#  logo         :string(255)
#  name         :string(255)
#  instructions :text(65535)
#  active       :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  amount       :decimal(10, 4)
#  cap          :integer          default(0)
#  reward_later :boolean          default(FALSE)
#

class Offer < ApplicationRecord
  validates :company_id, :link, :logo, :name, :instructions, :amount, presence: true

  mount_uploader :logo, OfferImageUploader
end
