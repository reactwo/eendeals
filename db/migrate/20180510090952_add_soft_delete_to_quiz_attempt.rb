class AddSoftDeleteToQuizAttempt < ActiveRecord::Migration[5.1]
  def change
    add_column :quiz_attempts, :deleted_at, :datetime
    add_reference :quiz_attempts, :old_user, foreign_key: true
  end
end
