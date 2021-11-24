class AddTokenHashToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token_hash, :text
  end
end
