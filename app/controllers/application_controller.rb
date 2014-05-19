class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :oauth, :signed_in?, :current_user

  def oauth
    DropboxOAuth2Flow.new(
      ENV['DROPBOX_KEY'],
      ENV['DROPBOX_SECRET'],
      redirect_url,
      session,
      :dropbox_auth_csrf_token
    )
  end

  def redirect_url
    "#{request.protocol}#{request.host_with_port}/oauth2/callback"
  end

  def current_user
    if session[:user_id]
      User.find(session[:user_id])
    end
  end

  def signed_in?
    current_user.present?
  end
end
