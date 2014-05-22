class User < ActiveRecord::Base
  has_many :sites
  validates :sites, length: { maximum: 1 }, unless: :subscriber?

  after_save :setup_s3_webhooks

  def directories
    sites.map(&:domain)
  end

  def subscriber?
    stripe_token.present?
  end

  def subscribe(subscription)
    self.stripe_token = subscription[:stripe_token]

    create_plan

    save
  end

  def create_plan
    customer = Stripe::Customer.create(
      :card => stripe_token,
      :plan => "unlimited",
    )
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
