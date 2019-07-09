class CreateYouTubes < ActiveRecord::Migration[5.1]
  def change
    create_table :you_tubes do |t|
      t.string :link

      t.timestamps
    end
  end
end
