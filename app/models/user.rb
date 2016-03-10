class User < ActiveRecord::Base
  has_many :sites
  validates :sites, length: { maximum: 1 }, unless: :subscriber?

  after_save :setup_s3_webhooks

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

  def delete_all_but_one_site
    sites.where.not(id: sites.last).destroy_all
  end

  def setup_s3_webhooks
    HTTParty.post(
      "#{ENV['DROPBOX_S3_WEBHOOK_URL']}users",
        query: {
          id: dropbox_user_id,
          user: {
            token: token
          }
        }
    )
  end
end
