class CreateLimits < ActiveRecord::Migration[5.1]
  def change
    create_table :limits do |t|
      t.integer :video1
      t.integer :video2
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
