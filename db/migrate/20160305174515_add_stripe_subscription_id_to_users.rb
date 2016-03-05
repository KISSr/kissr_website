class AddStripeSubscriptionIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_subscription_id, :string
  end
end
