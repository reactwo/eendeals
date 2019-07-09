# == Schema Information
#
# Table name: transactions
#
#  id               :integer          not null, primary key
#  amount           :decimal(10, 4)
#  category         :integer
#  direction        :integer
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  from_user_id     :integer
#  data             :text(65535)
#  from_user_status :integer
#  deleted_at       :datetime
#  old_user_id      :integer
#

class Transaction < ApplicationRecord
  has_soft_delete validate: false
  validates :amount, :category, :direction, :user_id, :from_user_id, :from_user_status, presence: true

  belongs_to :user
  belongs_to :old_user, required: false
  belongs_to :from_user, class_name: 'User'

  CATEGORY = {
      video1: 1,
      video2: 2,
      monthly: 3,
      refer: 4,
      phono: 5,
      conversionx: 6,
      icubeswire: 7,
      vcommission: 8,
      task: 9,
      refer_active: 10,
      deal: 11,
      custom: 12,
      paytm: 13,
      paypal: 14,
      skrill: 15,
      bank: 16,
      rubicko: 17,
      products: 18,
      tapjoy: 19,
      vnative: 20,
      game2048: 21,
      duplicate: 22,
      payza: 23,
      daily: 24,
      bkash: 25,
      screen_lock: 26,
      downline: 27,
      spin_wheel: 28,
      khabri_ustad: 29,
      redeem_reject: 30,
      sl_to_ed: 31,
      ed_ads: 32
  }.freeze

  CATEGORY_REVERSE = {
      1 => 'Video 1',
      2 => 'Video 2',
      3 => 'Monthly',
      4 => 'Referral',
      5 => 'Phono',
      6 => 'ConversionX',
      7 => 'iCubeswire',
      8 => 'vCommission',
      9 => 'Task',
      10 => 'Referral Transaction to Active',
      11 => 'Deal',
      12 => 'Custom',
      13 => 'PayTM',
      14 => 'PayPal',
      15 => 'Skrill',
      16 => 'Bank',
      17 => 'Rubicko',
      18 => 'Products',
      19 => 'TapJoy',
      20 => 'vNative',
      21 => '2048',
      22 => 'Duplicate entries',
      23 => 'PayZA',
      24 => 'Daily',
      25 => 'bKash',
      26 => 'Screen Lock',
      27 => 'Downline',
      28 => 'Spin Wheel',
      29 => 'Khabri Ustad',
      30 => 'Redeem Rejected',
      31 => 'Screen Lock to Wallet',
      32 => 'EdAds'
  }

  SHOW_CATEGORY_REVERSE = {
      1 => 'Video 1',
      2 => 'Video 2',
      3 => 'Monthly',
      4 => 'Referral',
      5 => 'Deal/Offer',
      6 => 'Deal/Offer',
      7 => 'Deal/Offer',
      8 => 'Deal/Offer',
      9 => 'Task',
      10 => 'Referral Transaction to Active',
      11 => 'Deal',
      12 => 'Custom',
      13 => 'PayTM',
      14 => 'PayPal',
      15 => 'Skrill',
      16 => 'Bank',
      17 => 'Offer Wall',
      18 => 'Products',
      19 => 'Video/Offer Wall',
      20 => 'Offer/Deal',
      21 => '2048',
      22 => 'Duplicate entries',
      23 => 'PayZA',
      24 => 'Daily',
      25 => 'bKash',
      26 => 'Screen Lock',
      27 => 'Downline',
      28 => 'Spin Wheel',
      29 => 'Khabri Ustad',
      30 => 'Redeem Rejected',
      31 => 'Screen Lock to Wallet',
      32 => 'EdAds'
  }

  DIRECTION = {
      credit: 1,
      debit: 2
  }

  DIRECTION_REVERSE = {
      1 => 'Credit',
      2 => 'Debit'
  }

  def self.activate_transactions(user_id)
    Transaction.transaction do
      Transaction.where(from_user_id: user_id, from_user_status: User::STATUS[:verified], direction: Transaction::DIRECTION[:credit]).in_batches.each do |transactions|
        transactions.each do |transaction|
          if transaction.from_user_id != transaction.user_id
            if transaction.category === Transaction::CATEGORY[:refer]
              t = Transaction.new
              t.amount = -transaction.amount
              t.direction = Transaction::DIRECTION[:debit]
              t.user = transaction.user
              t.from_user_id = user_id
              t.from_user_status = User::STATUS[:verified]
              t.category = Transaction::CATEGORY[:refer_active]
              t.save!
            end


            t1 = Transaction.new
            t1.amount = transaction.amount
            t1.direction = Transaction::DIRECTION[:credit]
            t1.user = transaction.user
            t1.from_user_id = user_id
            t1.from_user_status = User::STATUS[:approved]
            t1.category = transaction.category
            t1.save!

            wallet = transaction.user.wallet
            if wallet
              wallet.passive -= transaction.amount
              wallet.active += transaction.amount
              wallet.save!
            end
          end
        end
      end
    end
  end

  def distribute_upline(amount)
    user = self.user
    sponsor = self.user.sponsor
    level = 0
    distribution = [1.75, 1.5, 1.5, 1.25, 0.5, 0.5, 0.25, 0.25, 0.25, 0.25]
    Transaction.transaction do
      while !sponsor.nil? && level <= 9
        transaction = Transaction.new(
            category: Transaction::CATEGORY[:downline],
            direction: Transaction::DIRECTION[:credit],
            user: sponsor,
            from_user: user,
            from_user_status: user.status,
            amount: amount.to_f * (distribution[level] / 100),
            data: "{user_id: #{user.id}}"
        )

        transaction.save!

        wallet = sponsor.wallet
        if wallet
          wallet.add_money transaction.amount
        end

        level += 1
        sponsor = sponsor.sponsor
      end
    end
  end

  def distribute_upline_lock(amount)
    user = self.user
    sponsor = self.user.sponsor
    level = 0
    distribution = [133.33, 80, 53.33, 53.33, 26.67, 21.33, 18.67, 6.93, 4.00, 8.00]
    Transaction.transaction do
      while !sponsor.nil? && level <= 9
        transaction = Transaction.new(
            category: Transaction::CATEGORY[:screen_lock],
            direction: Transaction::DIRECTION[:credit],
            user: sponsor,
            from_user: user,
            from_user_status: User::STATUS[:lockscreen],
            amount: amount.to_f * (distribution[level] / 100)
        )

        transaction.save!

        wallet = sponsor.wallet
        if wallet
          wallet.add_money_lockscreen transaction.amount
        else
          transaction.destroy
        end

        level += 1
        sponsor = sponsor.sponsor
      end
    end
  end
end
