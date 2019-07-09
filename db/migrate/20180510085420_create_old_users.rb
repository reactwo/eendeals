class CreateOldUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :old_users do |t|
      t.string :email
      t.string :mobile
      t.string :name
      t.string :refer_id
      t.string :sponsor_id
      t.string :real_sponsor_id
      t.integer :status

      t.timestamps
    end
  end
end
