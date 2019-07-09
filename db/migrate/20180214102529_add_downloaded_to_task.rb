class AddDownloadedToTask < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :downloaded, :integer, default: 0
  end
end
