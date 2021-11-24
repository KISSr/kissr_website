class User < ActiveRecord::Base
  has_many :sites
  validates :sites, length: { maximum: 1 }, unless: :subscriber?

  def self.create_from_access_token(access_token) 
    client = DropboxApi::Client.new(access_token: access_token)
    dropbox_user = client.get_current_account.to_hash
    dropbox_user.inspect
    User.where(dropbox_user_id: dropbox_user["account_id"]).first_or_create(
      token: access_token.token,
      first_name: dropbox_user["first_name"],
      last_name: dropbox_user["last_name"],
      email: dropbox_user["email"]
    )
  end

  def directories
    sites.map(&:domain)
  end

  def subscriber?
    stripe_subscription_id.present?
  end

  def subscribe(subscription)
    customer = Stripe::Customer.create(
      :card => subscription[:stripe_token],
      :plan => "unlimited",
      :email => email,
      :metadata => {
        "User ID" => id,
        "Name" => "#{first_name} #{last_name}",
      }
    )

    self.stripe_customer_id = customer.id
    self.stripe_subscription_id = customer.subscriptions.data.last.id

    save
  end

  def unsubscribe
    Stripe::Customer
      .retrieve(stripe_customer_id)
      .subscriptions
      .retrieve(stripe_subscription_id)
      .delete

    delete_all_but_one_site
    update(stripe_subscription_id: nil)
  end

  def dropbox_client()
    if token_hash
    access_token = OAuth2::AccessToken.from_hash(DropboxAuthenticator.new, token_hash)
    DropboxApi::Client.new(
      access_token: access_token,
      on_token_refreshed: lambda { |new_token_hash|
        self.update_attribute(:token_hash, new_token_hash)
      }
    )
    else
    DropboxApi::Client.new(
      token,
      on_token_refreshed: lambda { |new_token_hash|
        self.update_attribute(:token_hash, new_token_hash)
      }
    )
    end
  end


  def delete_all_but_one_site
    sites.where.not(id: sites.last).destroy_all
  end
end
