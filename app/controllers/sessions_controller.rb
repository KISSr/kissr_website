class SessionsController < ApplicationController
  def create
    login

    if session[:site_domain]
      create_site
    else
      redirect_to sites_path
    end
  end

  def destroy
    session.delete(:user_id)

    redirect_to root_path
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

  def login
    session[:user_id] = user_from_oauth.id
  end

  def user_from_oauth
    access_token, user_id, _ = oauth.finish(params)

    user = User.where(dropbox_user_id: user_id).first_or_create
    user.update_attributes(user_attributes(access_token))
    user
  end

  def user_attributes(access_token)
    dropbox_account_info = DropboxClient.new(access_token).account_info

    {
      token: access_token,
      first_name: dropbox_account_info["name_details"]["given_name"],
      last_name: dropbox_account_info["name_details"]["surname"],
      email: dropbox_account_info["email"],
    }
  end
end
