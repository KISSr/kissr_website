class Site < ActiveRecord::Base
  belongs_to :user
  validates :domain, presence: true, uniqueness: true

  after_save :create_dropbox_folder
  after_create :email_admin

  def create_dropbox_folder
    Dir["#{Rails.root}/templates/default/**/**"].each do |file|
      unless File.directory?(file)
        destination_path= "/#{domain}/#{file.sub("#{Rails.root}/templates/default/","")}"
        puts destination_path
        user.dropbox_client.upload(
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
end
