# == Schema Information
#
# Table name: conversions
#
#  id             :integer          not null, primary key
#  transaction_id :string(255)
#  company        :string(255)
#  company_id     :string(255)
#  offer_id       :integer
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  deal_id        :integer
#  status         :integer
#  product_id     :integer
#  deleted_at     :datetime
#  old_user_id    :integer
#

class Conversion < ApplicationRecord
  has_soft_delete validate: false
  belongs_to :offer, optional: true
  belongs_to :deal, optional: true
  belongs_to :product, optional: true
  belongs_to :user
  belongs_to :old_user, required: false

  validates :transaction_id, :company_id, :company, :user_id, presence: true
  validates :transaction_id, uniqueness: true

  STATUS = {
      unapproved: 1,
      approved: 2
  }.freeze

  STATUS_REVERSE = {
      1 => 'Unapproved',
      2 => 'Approved'
  }.freeze
end
