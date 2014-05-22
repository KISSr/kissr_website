class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :cursor
      t.string :dropbox_user_id
      t.string :token
      t.string :stripe_token

      t.timestamps
    end
  end
end
