class CreateCustomFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :custom_files do |t|
      t.string :file

      t.timestamps
    end
  end
end
