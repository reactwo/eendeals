class QuizAttemptDatatable < AjaxDatatablesRails::Base

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: 'QuizAttempt.id', cond: :eq },
      name: { source: 'QuizAttempt.user.name', cond: :like },
      status: { source: 'QuizAttempt.status', cond: :eq },
      points: { source: 'QuizAttempt.points', cond: :eq },
      date: { source: 'QuizAttempt.created_at', cond: :eq }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        name: record.user.name,
        status: QuizAttempt::STATUS_REVERSE[record.status],
        points: record.points,
        user_id: record.user_id,
        date: record.created_at.in_time_zone('New Delhi').strftime('%d %b %Y %H:%M')
      }
    end
  end

  private

  def get_raw_records
    QuizAttempt.order(id: :desc)
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
