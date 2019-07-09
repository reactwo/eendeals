class AddSoftDeleteToQuizWinner < ActiveRecord::Migration[5.1]
  def change
    add_column :quiz_winners, :deleted_at, :datetime
    add_reference :quiz_winners, :old_user, foreign_key: true
  end
end
