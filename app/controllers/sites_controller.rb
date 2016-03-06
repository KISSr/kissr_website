class SitesController < ApplicationController
  before_filter :redirect_unless_subscriber, only: :new
  before_filter :authorize

  def index
    @sites = current_user.sites.all
  end

  def new
    @site = Site.new
  end

  def create
    @site = Site.new(site_params.merge(user: current_user))

    if @site.save
      redirect_to sites_path
    else
      render :new
    end
  end

  def destroy
    Site.find(params[:id]).destroy

    redirect_to sites_path
  end

  def site_params
    params.require(:site).permit(:domain)
  end

  def redirect_unless_subscriber
    unless current_user.subscriber? || current_user.sites.empty?
      redirect_to sites_path
    end
  end
end
