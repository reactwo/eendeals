# == Schema Information
#
# Table name: custom_files
#
#  id         :integer          not null, primary key
#  file       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string(255)
#

class CustomFile < ApplicationRecord

  mount_uploader :file, OfferImageUploader

end
