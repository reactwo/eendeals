# == Schema Information
#
# Table name: categories
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  image           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  banner_id       :string(255)
#  interstitial_id :string(255)
#  rewarded_id     :string(255)
#  task_id         :integer
#

class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :image, :task_id, :banner_id, :interstitial_id, :rewarded_id, :done

  def image
    object.image.url
  end

  def done
    user = User.find_by_refer_id scope[:refer_id]
    if user
      reward = RewardTask.find_by(task_id: object.task_id, user: user.id)
      if reward
        return true
      else
        return false
      end
    else
      false
    end
  end
end
