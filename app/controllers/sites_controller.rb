class SitesController < ApplicationController
  before_filter :authorize

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

  def destroy
    Site.find(params[:id]).destroy

    redirect_to sites_path
  end

  def site_params
    params.require(:site).permit(:name)
  end

  def authorize
    unless signed_in?

      if params[:site]
        session[:site_name] = params[:site][:name]
      end

      redirect_to oauth.start
    end
  end
end
