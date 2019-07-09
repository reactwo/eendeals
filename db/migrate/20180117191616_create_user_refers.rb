class CreateUserRefers < ActiveRecord::Migration[5.1]
  def change
    create_table :user_refers do |t|
      t.belongs_to :user, foreign_key: true
      t.integer :down_user_id
      t.integer :level, default: 0

      t.timestamps
    end
  end
end
