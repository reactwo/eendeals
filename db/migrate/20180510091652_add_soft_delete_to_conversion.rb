class AddSoftDeleteToConversion < ActiveRecord::Migration[5.1]
  def change
    add_column :conversions, :deleted_at, :datetime
    add_reference :conversions, :old_user, foreign_key: true
  end
end
