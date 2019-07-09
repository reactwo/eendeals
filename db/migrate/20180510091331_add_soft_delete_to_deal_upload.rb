class AddSoftDeleteToDealUpload < ActiveRecord::Migration[5.1]
  def change
    add_column :deal_uploads, :deleted_at, :datetime
    add_reference :deal_uploads, :old_user, foreign_key: true
  end
end
