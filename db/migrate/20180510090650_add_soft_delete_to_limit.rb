class AddSoftDeleteToLimit < ActiveRecord::Migration[5.1]
  def change
    add_column :limits, :deleted_at, :datetime
    add_reference :limits, :old_user, foreign_key: true
  end
end
