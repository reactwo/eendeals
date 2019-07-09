# == Schema Information
#
# Table name: redeems
#
#  id          :integer          not null, primary key
#  mobile      :string(255)
#  account_no  :string(255)
#  ifsc        :string(255)
#  bank_name   :string(255)
#  name        :string(255)
#  email       :string(255)
#  coins       :decimal(10, 4)
#  user_id     :integer
#  status      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  kind        :integer
#  swift_code  :string(255)
#  deleted_at  :datetime
#  old_user_id :integer
#  reason      :string(255)
#

class Redeem < ApplicationRecord
  has_soft_delete validate: false
  belongs_to :user
  belongs_to :old_user, required: false

  validates :kind, :user_id, :status, :coins, presence: true
  validate :details

  KIND = {
      paytm: 1,
      bank: 2,
      paypal: 3,
      skrill: 4,
      payza: 5,
      bkash: 6,
      ed_ads: 7
  }.freeze

  KIND_REVERSE = {
      1 => 'PayTM',
      2 => 'Bank',
      3 => 'PayPal',
      4 => 'Skrill',
      5 => 'PayZA',
      6 => 'bKash',
      7 => 'EdAds'
  }.freeze

  KIND_MAPPING_TRANSACTION = {
      1 => 13,
      2 => 16,
      3 => 14,
      4 => 15,
      5 => 23,
      6 => 25,
      7 => 32
  }

  STATUS = {
      submitted: 1,
      approved: 2,
      rejected: 3
  }.freeze

  STATUS_REVERSE = {
      1 => 'Submitted',
      2 => 'Approved',
      3 => 'Rejected'
  }.freeze

  def details
    if kind === KIND[:paytm]
      if mobile.blank?
        errors.add(:mobile, :blank)
      end
    elsif kind === KIND[:bank]
      if account_no.blank?
        errors.add(:account_no, :blank)
      elsif ifsc.blank?
        errors.add(:ifsc, :blank)
      elsif bank_name.blank?
        errors.add(:bank_name, :blank)
      elsif name.blank?
        errors.add(:name, :blank)
      elsif swift_code.blank?
        errors.add(:swift_code, :blank)
      end
    elsif (kind === KIND[:paypal]) || (kind === KIND[:skrill])
      if email.blank?
        errors.add(:email, :blank)
      end
    elsif kind === KIND[:bkash]
      if mobile.blank?
        errors.add(:mobile, :blank)
      elsif email.blank?
        errors.add(:email, :blank)
      end
    end
  end

end
