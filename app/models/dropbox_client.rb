class DropboxClient < DropboxApi::Client
  def self.from_code(code)
    access_token = DropboxAuthenticator.new.get_token(
      redirect_uri: Rails.application.routes.url_helpers.dropbox_auth_callback_url,
      code: code
    )

    new(access_token: access_token)
  end
end

