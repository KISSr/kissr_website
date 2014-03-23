class PagesController < ApplicationController
  include HighVoltage::StaticPage

  before_filter :redirect_if_logged_in

  private

  def redirect_if_logged_in
    if params[:id] == 'home' && signed_in?
      redirect_to sites_path
    end
  end
end
