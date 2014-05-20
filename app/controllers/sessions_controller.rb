class SessionsController < ApplicationController
  def create
    login
    create_site

    redirect_to sites_path
  end

  def destroy
    session.delete(:user_id)

    redirect_to root_path
  end

  def create_site
    if session[:site_name]
      Site.create(
        user: current_user,
        name: session.delete(:site_name)
      )
    end
  end

  def login
    session[:user_id] = user_from_oauth.id
  end

  def user_from_oauth
    access_token, user_id, url_state = oauth.finish(params)

    user = User.where(dropbox_user_id: user_id).first_or_create
    user.update_attributes(token: access_token)
    user
  end
end
