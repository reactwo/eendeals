# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  message    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Notification < ApplicationRecord

  def self.send_notifications(message, users)
    n = Rpush::Gcm::Notification.new
    n.app = Rpush::Gcm::App.first
    n.registration_ids = users
    n.data = { message: message }
    n.priority = 'high'        # Optional, can be either 'normal' or 'high'
    n.notification = {
        sound: 'default',
        body: message
    }
    n.save!
  end

end
