class AddAdMobToCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :banner_id, :string
    add_column :categories, :interstitial_id, :string
    add_column :categories, :rewarded_id, :string
  end
end
