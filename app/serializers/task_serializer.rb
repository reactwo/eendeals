# == Schema Information
#
# Table name: tasks
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  instructions   :text(65535)
#  amount         :decimal(10, )
#  link           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  active         :boolean          default(FALSE)
#  cap            :integer          default(0)
#  downloaded     :integer          default(0)
#  picture_upload :boolean          default(TRUE)
#  run_days       :integer          default(1)
#  parent_id      :integer
#  start_time     :datetime
#  end_time       :datetime
#  slug           :string(255)
#

class TaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :instructions, :amount, :link, :picture_upload
end
