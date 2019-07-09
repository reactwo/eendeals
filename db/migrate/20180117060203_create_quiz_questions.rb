class CreateQuizQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :quiz_questions do |t|
      t.text :question
      t.string :choice_1
      t.string :choice_2
      t.string :choice_3
      t.string :choice_4
      t.string :correct_choice
      t.belongs_to :quiz, foreign_key: true

      t.timestamps
    end
  end
end
