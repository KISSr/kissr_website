class Site < ActiveRecord::Base
  belongs_to :user
  validates :domain, presence: true, uniqueness: true

  after_save :update_s3_webhooks
  after_save :create_dropbox_folder

  def create_dropbox_folder
    Dir["#{Rails.root}/templates/default/**/**"].each do |file|
      unless File.directory?(file)
        destination_path= "#{domain}/#{file.sub("#{Rails.root}/templates/default","")}"
        dropbox.put_file(destination_path, File.new(file,'r'))
      end
    end
  end

  def dropbox
    @dropbox ||= DropboxClient.new(user.token)
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
