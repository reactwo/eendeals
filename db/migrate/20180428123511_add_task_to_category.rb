class AddTaskToCategory < ActiveRecord::Migration[5.1]
  def change
    add_reference :categories, :task, foreign_key: true
  end
end
