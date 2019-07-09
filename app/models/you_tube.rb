# == Schema Information
#
# Table name: you_tubes
#
#  id         :integer          not null, primary key
#  link       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string(255)
#

class YouTube < ApplicationRecord

  validates :link, :name, presence: true

end
