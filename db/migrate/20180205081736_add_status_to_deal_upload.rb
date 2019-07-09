class AddStatusToDealUpload < ActiveRecord::Migration[5.1]
  def change
    add_column :deal_uploads, :status, :boolean, default: false
  end
end
