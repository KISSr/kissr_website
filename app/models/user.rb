class User < ActiveRecord::Base
  has_many :sites

  after_save :setup_s3_webhooks

  def directories
    sites.map(&:domain)
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
