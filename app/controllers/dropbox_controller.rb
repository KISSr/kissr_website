class DropboxController < ApplicationController
  before_filter :block_spam

  def auth
    if params[:site]
      session[:site_domain] = params[:site][:domain]
    end

    redirect_to oauth2_redirect_url
  end

  def auth_callback
    user = create_user_from_oauth(get_token())
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

  def create_user_from_oauth(token)
    client = DropboxApi::Client.new(token)
    dropbox_user = client.get_current_account.to_hash
    User.where(dropbox_user_id: dropbox_user["account_id"]).first_or_create(
      token: token,
      first_name: dropbox_user["first_name"],
      last_name: dropbox_user["last_name"],
      email: dropbox_user["email"]
    )
  end

  private

  def authenticator
    DropboxApi::Authenticator.new(ENV['DROPBOX_KEY'], ENV['DROPBOX_SECRET'])
  end

  def get_token
    authenticator.get_token(
      params[:code],
      redirect_uri: dropbox_auth_callback_url
    ).token
  end

  def oauth2_redirect_url
    authenticator.authorize_url(
      redirect_uri: dropbox_auth_callback_url
    )
  end

  def block_spam
    if session[:site_domain].try(:include?, "parak") ||
      session[:site_domain].try(:include?, "par") ||
      session[:site_domain].try(:include?, "bank") ||
      session[:site_domain].try(:include?, "pay")
      return render text: "Authorities have ben notified", status: 403
    end
  end
end
