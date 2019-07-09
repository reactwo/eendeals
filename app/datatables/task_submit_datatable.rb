class TaskSubmitDatatable < AjaxDatatablesRails::Base

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: 'TaskSubmit.id', cond: :eq },
      name: { source: 'TaskSubmit.Task.name', cond: :eq },
      user: { source: 'TaskSubmit.User.name', cond: false },
      created_at: { source: 'TaskSubmit.created_at', cond: false },
      status: { source: 'TaskSubmit.status', cond: :eq },
      image: { source: 'TaskSubmit.image', cond: false }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        name: record.task.name,
        user: record.user.name,
        created_at: record.created_at.in_time_zone('New Delhi').strftime('%d %b %Y %H:%M'),
        status: "#{TaskSubmit::STATUS_REVERSE[record.status]}",
        image: record.image.url
      }
    end
  end

  private

  def get_raw_records
    TaskSubmit.all.order(id: :desc)
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
