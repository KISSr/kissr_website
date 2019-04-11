class Site < ActiveRecord::Base
  belongs_to :user
  validates :domain, presence: true, uniqueness: true

  after_save :update_s3_webhooks
  after_save :create_dropbox_folder
  # after_create :email_admin

  def create_dropbox_folder
    Dir["#{Rails.root}/templates/default/**/**"].each do |file|
      unless File.directory?(file)
        destination_path= "/#{domain}/#{file.sub("#{Rails.root}/templates/default/","")}"
        puts destination_path
        dropbox.upload(
          destination_path,
          File.new(file,'r'),
          autorename: true,
          mode: :add
        )
      end
    end
  end

  def email_admin
    AdminMailer.site_created_email(self).deliver_later
  end

  def dropbox
    @dropbox ||= DropboxApi::Client.new(user.token)
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
