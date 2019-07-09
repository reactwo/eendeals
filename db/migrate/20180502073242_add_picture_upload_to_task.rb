class AddPictureUploadToTask < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :picture_upload, :boolean, default: true
  end
end
