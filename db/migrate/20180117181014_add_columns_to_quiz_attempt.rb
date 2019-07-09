class AddColumnsToQuizAttempt < ActiveRecord::Migration[5.1]
  def change
    add_column :quiz_attempts, :status, :integer, default: 1
    add_column :quiz_attempts, :points, :decimal, scale: 4, precision: 10
  end
end
