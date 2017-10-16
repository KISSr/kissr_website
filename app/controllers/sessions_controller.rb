class SessionsController < ApplicationController
  def destroy
    session.delete(:user_id)

    redirect_to root_path
  end
end
