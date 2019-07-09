class AddSoftDeleteToRedeem < ActiveRecord::Migration[5.1]
  def change
    add_column :redeems, :deleted_at, :datetime
    add_reference :redeems, :old_user, foreign_key: true
  end
end
