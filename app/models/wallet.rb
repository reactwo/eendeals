# == Schema Information
#
# Table name: wallets
#
#  id            :integer          not null, primary key
#  active        :decimal(10, 4)
#  passive       :decimal(10, 4)
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  activation    :decimal(10, 4)   default(0.0)
#  deleted_at    :datetime
#  old_user_id   :integer
#  redeem        :decimal(10, 4)   default(0.0)
#  screen_lock   :decimal(10, 4)   default(0.0)
#  total_earning :decimal(10, 4)   default(0.0)
#  total_redeem  :decimal(10, 4)   default(0.0)
#

class Wallet < ApplicationRecord
  has_soft_delete validate: false
  validates :active, :passive, :user_id, presence: true

  belongs_to :user
  belongs_to :old_user, required: false

  def add_money(amount)
    if user.status === User::STATUS[:verified]
      self.activation += amount
    elsif user.status === User::STATUS[:approved]
      self.active += amount
    end
    if self.activation >= 100
      left = self.activation - 100
      self.activation = 0
      self.active += left
      Transaction.activate_transactions self.user_id
      self.user.update(status: User::STATUS[:approved])
    end

    self.total_earning += amount

    self.save
  end

  def deduct_money(amount)
    if user.status === User::STATUS[:verified]
      self.activation -= amount
    elsif user.status === User::STATUS[:approved]
      self.active -= amount
    end
    self.save
  end

  def add_money_lockscreen(amount)
    self.screen_lock += amount.to_f
    self.save
  end
end
