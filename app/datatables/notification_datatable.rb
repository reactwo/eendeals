class NotificationDatatable < AjaxDatatablesRails::Base

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Notification.id", cond: :eq },
      message: { source: "Notification.message", cond: :like },
      created_at: { source: 'Notification.created_at', cond: false }
    }
  end

  def data
    records.map do |record|
      {
        # example:
        id: record.id,
        message: record.message,
        created_at: record.created_at.in_time_zone('New Delhi').strftime('%d %b %Y %H:%M')
      }
    end
  end

  private

  def get_raw_records
    Notification.all
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
