class QuizQuestionDatatable < AjaxDatatablesRails::Base

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "QuizQuestion.id", cond: :eq },
      question: { source: "QuizQuestion.question", cond: :like },
      date: { source: 'Quiz.date', cond: :eq },
      created_at: { source: 'Quiz.created_at', cond: false }
    }
  end

  def data
    records.map do |record|
      {
        # example:
        id: record.id,
        question: record.question,
        date: record.quiz.date,
        created_at: record.created_at.in_time_zone('New Delhi').strftime('%d %b %Y %H:%M')
      }
    end
  end

  private

  def get_raw_records
    ids = Quiz.where('DATE(date) > ?', Date.today - 1.day).pluck(:id)
    QuizQuestion.where('quiz_id IN (?)', ids)
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
