namespace :emails do
  desc "backfill subscriptions"
  task backfill: :environment do
    User.all.each do |user|
      begin
        dropbox_account_info = DropboxClient.new(user.token).account_info
        user.update_attributes({
          first_name: dropbox_account_info["name_details"]["given_name"],
          last_name: dropbox_account_info["name_details"]["surname"],
          email: dropbox_account_info["email"],
        })
      rescue DropboxAuthError
        puts "Could not update user ##{user.id}"
      end
    end
  end

  task backfill_into_stripe: :environment do
    User.all.each do |user|
      stripe_customer = Stripe::Customer.retrieve(user.stripe_customer_id)
      stripe_customer.email = "#{user.email}"
      stripe_customer.metadata = {
        "User ID" => user.id,
        "Name" => "#{user.first_name} #{user.last_name}",
      }
      stripe_customer.save
      puts "Updated #{user.stripe_customer_id}"
    end
  end
end
