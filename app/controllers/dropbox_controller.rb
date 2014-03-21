require 'dropbox_sdk'

class DropboxController < ApplicationController
  APP_KEY = 'ujdsycik761l86k'
  APP_SECRET = 't8tqmjuu7s1bnud'

  def index
    authorize_url = get_flow().start()
    redirect_to authorize_url, status: 302
  end

  def get_flow
    redirect_url = url_for :action => 'accepted', :controller => 'dropbox'
    flow = DropboxOAuth2Flow.new(APP_KEY, APP_SECRET, redirect_url, session, :dropbox_auth_csrf_token)
    return flow
  end

  def accepted
    flow = get_flow()
    @access_token, user_id = flow.finish(request.GET)
  end
end
