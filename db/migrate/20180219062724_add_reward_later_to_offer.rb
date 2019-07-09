class AddRewardLaterToOffer < ActiveRecord::Migration[5.1]
  def change
    add_column :offers, :reward_later, :boolean, default: false
  end
end
