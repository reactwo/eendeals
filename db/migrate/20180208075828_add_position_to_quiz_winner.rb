class AddPositionToQuizWinner < ActiveRecord::Migration[5.1]
  def change
    add_column :quiz_winners, :position, :integer
  end
end
