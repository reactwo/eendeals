# == Schema Information
#
# Table name: wallpapers
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  image       :string(255)
#  downloaded  :integer          default(0)
#  premium     :boolean          default(FALSE)
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class WallpaperSerializer < ActiveModel::Serializer
  attributes :id, :name, :image, :downloaded, :premium

  def image
    object.image.url
  end
end
