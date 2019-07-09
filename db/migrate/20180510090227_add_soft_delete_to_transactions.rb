class AddSoftDeleteToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :deleted_at, :datetime
    add_reference :transactions, :old_user, foreign_key: true
  end
end
