class DomainsController < ApplicationController
  def index
    if Site.find_by_domain(params[:domain])
      head 200
    else
      head 404
    end
  end
end
