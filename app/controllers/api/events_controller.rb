class Api::EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    response.headers['X-Content-Type-Options'] = 'nosniff'
    render plain: params[:challenge]
  end

  def create
    params[:list_folder][:accounts].each do |dropbox_user_id|
      user = User.find_by_dropbox_user_id(dropbox_user_id)
      dropbox_syncer = DropboxSyncer.new(user)
      dropbox_syncer.sync
    end

    head :ok
  end
end
