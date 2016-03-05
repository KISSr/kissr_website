class RenameStripeTokenToStripeCustomerId < ActiveRecord::Migration
  def change
    rename_column :users, :stripe_token, :stripe_customer_id
  end
end
