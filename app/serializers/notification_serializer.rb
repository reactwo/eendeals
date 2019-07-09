# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  message    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :message, :date

  def date
    object.created_at.strftime('%d/%m/%Y')
  end
end
