class AddDataToTransaction < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :data, :text
  end
end
