# == Schema Information
#
# Table name: old_users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  mobile          :string(255)
#  name            :string(255)
#  refer_id        :string(255)
#  sponsor_id      :string(255)
#  real_sponsor_id :string(255)
#  status          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class OldUser < ApplicationRecord

  has_one :wallet
  has_many :transactions

end
