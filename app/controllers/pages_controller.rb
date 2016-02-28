class PagesController < ApplicationController
  include HighVoltage::StaticPage
  layout :layout_for_page

  before_filter :redirect_if_logged_in

  private

  def redirect_if_logged_in
    if params[:id] == 'home' && signed_in?
      redirect_to sites_path
    end
  end

  def layout_for_page
    case params[:id]
    when 'home'
      'home'
    else
      'application'
    end
  end
end
