namespace :subscriptions do
  desc "backfill subscriptions"
  task backfill: :environment do
    User.where("stripe_customer_id like 'tok_%'").each do |user|
      token = Stripe::Token.retrieve(user.stripe_customer_id)
      customer = Stripe::Customer.retrieve(token.card.customer)
      subscription_id = customer.subscriptions.data.last.try(:id)

      puts "Updating #{customer.id} #{subscription_id}"
      user.assign_attributes(
        stripe_customer_id: customer.id,
        stripe_subscription_id: subscription_id,
      )
      user.save(validate: false)
    end
  end
end
