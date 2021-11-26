class DropboxController < ApplicationController
  before_action :block_spam

  def auth
    if params[:site]
      session[:site_domain] = params[:site][:domain]
    end

    redirect_to oauth2_redirect_url
  end

  def auth_callback
    access_token = DropboxAuthenticator.new.auth_code.get_token(
      params[:code],
      redirect_uri: dropbox_auth_callback_url,
    )
    user = User.create_from_access_token(access_token)
    session[:user_id] = user.id

    if session[:site_domain]
      create_site
    else
      redirect_to sites_path
    end
  end

  def create_site
    @site = Site.create(
      user: current_user,
      domain: session.delete(:site_domain)
    )

    if @site.save
      redirect_to sites_path
    else
      render 'sites/new'
    end
  end


  private

  def oauth2_redirect_url
    DropboxAuthenticator.new.auth_code.authorize_url(
      redirect_uri: dropbox_auth_callback_url,
      token_access_type: 'offline',
    )
  end

  def block_spam
    if session[:site_domain].try(:include?, "parak") ||
      session[:site_domain].try(:include?, "par") ||
      session[:site_domain].try(:include?, "bank") ||
      session[:site_domain].try(:include?, "slot") ||
      session[:site_domain].try(:include?, "sha") ||
      session[:site_domain].try(:include?, "pay")
      return render text: "Authorities have ben notified", status: 403
    end
  end
end
