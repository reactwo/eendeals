# == Schema Information
#
# Table name: transactions
#
#  id               :integer          not null, primary key
#  amount           :decimal(10, 4)
#  category         :integer
#  direction        :integer
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  from_user_id     :integer
#  data             :text(65535)
#  from_user_status :integer
#  deleted_at       :datetime
#  old_user_id      :integer
#

class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :category, :direction, :from_user, :created_at

  def category
    begin
      if object.category >= 5 and object.category <= 8
        ob = eval(object.data)
        if ob.has_key? :offer_id
          offer = Offer.find_by_id ob[:offer_id]
          if offer
            return "Offer: #{offer.name}"
          end
        elsif ob.has_key? :deal_id
          deal = Deal.find_by_id ob[:deal_id]
          if deal
            return "Deal: #{deal.name}"
          end
        end
      elsif object.category === Transaction::CATEGORY[:task]
        ob = eval(object.data)
        if ob.has_key? :task_submit_id
          task_submit = TaskSubmit.find_by_id ob[:task_submit_id]
          if task_submit
            return "Task: #{task_submit.task.name}"
          end
        end
      elsif object.category === Transaction::CATEGORY[:custom]
        return object.data
      elsif object.category === Transaction::CATEGORY[:redeem_reject]
        return object.data
      end
    rescue
      return Transaction::SHOW_CATEGORY_REVERSE[object.category]
    end
    Transaction::SHOW_CATEGORY_REVERSE[object.category]
  end

  def direction
    Transaction::DIRECTION_REVERSE[object.direction]
  end

  def from_user
    object.from_user.name
  end

  def created_at
    object.created_at.strftime('%d %b %Y %H:%M')
  end
end
