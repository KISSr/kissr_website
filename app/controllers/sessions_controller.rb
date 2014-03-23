class SessionsController < ApplicationController
  def create
    login

    redirect_to sites_path
  end

  def destroy
    session.delete(:user_id)

    redirect_to root_path
  end

  def login
    session[:user_id] = user_from_oauth.id
  end

  def user_from_oauth
    access_token, user_id, url_state = oauth.finish(params)

    user = User.first_or_create(dropbox_user_id: user_id)
    user.update_attributes(token: access_token)
    user
  end
end
