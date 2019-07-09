class CreateQuizWinners < ActiveRecord::Migration[5.1]
  def change
    create_table :quiz_winners do |t|
      t.belongs_to :quiz, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.decimal :points, scale: 4, precision: 10

      t.timestamps
    end
  end
end
