class DropboxAuthenticator < DropboxApi::Authenticator
  def initialize()
    super(ENV['DROPBOX_KEY'], ENV['DROPBOX_SECRET']) 
  end
end
