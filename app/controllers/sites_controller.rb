class SitesController < ApplicationController
  def index
    @sites = current_user.sites.all
  end

  def new
    @site = Site.new
  end

  def create
    Site.create(site_params.merge(user: current_user))

    redirect_to sites_path
  end

  def site_params
    params.require(:site).permit(:domain)
  end
end
