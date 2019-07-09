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

class WalletSerializer < ActiveModel::Serializer
  attributes :id, :active, :passive, :activation, :redeem, :screen_lock, :total_earning, :total_redeem
end
