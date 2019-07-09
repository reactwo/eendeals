class AddFromUserStatusToTransaction < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :from_user_status, :integer
  end
end
