class CreateQuizQuestionAttempts < ActiveRecord::Migration[5.1]
  def change
    create_table :quiz_question_attempts do |t|
      t.belongs_to :quiz_attempt, foreign_key: true
      t.belongs_to :quiz_question, foreign_key: true
      t.integer :selected_choice, default: 0

      t.timestamps
    end
  end
end
