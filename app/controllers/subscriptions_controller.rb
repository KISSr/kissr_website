class SubscriptionsController < ApplicationController
  def create
    if current_user.subscribe(params[:subscription])
      redirect_to sites_path
    else
      render :new
    end
  end
end
