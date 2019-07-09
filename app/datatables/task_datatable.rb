class TaskDatatable < AjaxDatatablesRails::Base

  def view_columns
    @view_columns ||= {
      id: { source: "Task.id", cond: :eq },
      name: { source: "Task.name", cond: :like },
      active: { source: "Task.active", cond: :like },
      created_at: { source: 'Task.created_at', cond: false }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        name: record.name,
        active: record.active,
        cap: record.cap,
        downloaded: record.downloaded,
        amount: total_amount(record),
        created_at: record.created_at.in_time_zone('New Delhi').strftime('%d %b %Y %H:%M')
      }
    end
  end

  private

  def get_raw_records
    Task.all
  end

  def total_amount(task)
    (task.task_submits.where(status: TaskSubmit::STATUS[:approved]).count + task.reward_tasks.count) * task.amount
  end

  # ==== These methods represent the basic operations to perform on records
  # and feel free to override them

  # def filter_records(records)
  # end

  # def sort_records(records)
  # end

  # def paginate_records(records)
  # end

  # ==== Insert 'presenter'-like methods below if necessary
end
