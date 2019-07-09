class AddTimeToQuizQuestionAttempt < ActiveRecord::Migration[5.1]
  def change
    add_column :quiz_question_attempts, :time_taken, :decimal, scale: 2, precision: 8, default: 0
  end
end
