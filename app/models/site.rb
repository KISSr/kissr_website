class Site < ActiveRecord::Base
  belongs_to :user
  validates :name, presence: true, uniqueness: true

  after_save :update_s3_webhooks

  def domain
    "#{name}.kissr.com"
  end

  def update_s3_webhooks
    HTTParty.put(
      "#{ENV['DROPBOX_S3_WEBHOOK_URL']}users/#{user.dropbox_user_id}",
      query: {
        user: {
          directories: user.directories
        }
      }
    )
  end
end
