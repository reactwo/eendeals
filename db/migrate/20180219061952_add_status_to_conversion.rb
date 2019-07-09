class AddStatusToConversion < ActiveRecord::Migration[5.1]
  def change
    add_column :conversions, :status, :integer
  end
end
