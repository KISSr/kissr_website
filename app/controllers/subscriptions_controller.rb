class SubscriptionsController < ApplicationController
  def create
    if current_user.subscribe(params[:subscription])
      redirect_to sites_path, notice: "Success! Thanks! Enjoy using KISSr!"
    else
      render :new
    end
  end

  def destroy
    current_user.unsubscribe
    redirect_to sites_path, notice: "You've been unsubscribed! We're sad to see you go but thanks for giving KISSr a try!"
  end
end
