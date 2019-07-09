class CreateDealUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :deal_uploads do |t|
      t.string :image
      t.belongs_to :deal, foreign_key: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
