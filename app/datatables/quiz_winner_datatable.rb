class QuizWinnerDatatable < AjaxDatatablesRails::Base

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "QuizWinner.id", cond: :eq },
      user_id: { source: 'QuizWinner.user_id', cond: false },
      quiz_id: { source: 'QuizWinner.quiz_id', cond: false },
      points: { source: 'QuizWinner.points', cond: false },
      poisition: { source: 'QuizWinner.position', cond: false },
      created_at: { source: 'QuizWinner.created_at', cond: false }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        user_id: record.user_id,
        quiz_id: record.quiz_id,
        points: record.points,
        position: record.position,
        created_at: record.created_at
      }
    end
  end

  private

  def get_raw_records
    QuizWinner.all
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
