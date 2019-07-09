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

class Task < ApplicationRecord

  before_create :random_slug

  validates :name, :instructions, :amount, presence: true

  has_many :task_submits
  has_many :reward_tasks

  def run_consecutive
    if end_time > DateTime.now
      task_count = Task.where('id = ? OR parent_id = ?', parent_id, parent_id).count
      if task_count < run_days
        new_task = self.dup
        new_task.active = true
        new_task.downloaded = 0
        new_task.save

        tomorrow = Date.today + 1.day
        running_time = DateTime.new(tomorrow.year, tomorrow.month, tomorrow.day)
        new_task.delay(run_at: running_time).run_consecutive

        self.active = false
        self.save
      end
    else
      self.active = false
      self.save
    end
  end

  private

  def random_slug
    if self.slug.nil? || self.slug.length === 0
      self.slug = DateTime.now.to_i + rand(10000)
    end
  end

end
