class RewardTaskDatatable < AjaxDatatablesRails::Base

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "RewardTask.id", cond: :eq },
      date: { source: 'RewardTask.created_at', cond: :eq }
    }
  end

  def data
    records.map do |record|
      {
        # example:
        id: record.id,
        task_id: record.task_id,
        task_name: record.task.name,
        user_id: record.user_id,
        user_name: record.user.name,
        date: record.created_at.in_time_zone('New Delhi').strftime('%d %b %Y %H:%M')
      }
    end
  end

  private

  def get_raw_records
    RewardTask.all.order(id: :desc)
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
