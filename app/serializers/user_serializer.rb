# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default("")
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  mobile                 :string(255)
#  gender                 :integer
#  name                   :string(255)
#  refer_id               :string(255)
#  sponsor_id             :string(255)
#  real_sponsor_id        :string(255)
#  authentication_token   :string(30)
#  status                 :integer          default(0)
#  token                  :string(255)
#  hollow                 :boolean          default(FALSE)
#  lock                   :boolean          default(FALSE)
#  lock_last              :date
#  game                   :boolean          default(FALSE)
#  game_last              :date
#

class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :mobile, :gender, :refer_id, :sponsor_id, :status, :authentication_token, :lock, :game, :hollow, :created_at

  def gender
    User::GENDER_REVERSE[object.gender]
  end

  def mobile
    begin
      if !current_user ||
          object.id != current_user.id
        if object.gender === User::GENDER[:female]
          return "XXXXX-X#{object.mobile.last(4)}"
        end
      end
      object.mobile
    rescue
      if object.gender === User::GENDER[:female]
        return "XXXXX-X#{object.mobile.last(4)}"
      end
      object.mobile
    end
  end

end
