require 'dropbox_sdk'

class DropboxController < ApplicationController
  APP_KEY = 'ujdsycik761l86k'
  APP_SECRET = 't8tqmjuu7s1bnud'

  def index
    if !session[:access_token] then redirect_to url_for :action => 'connect' end
  end

  def get_flow
    redirect_url = url_for :action => 'authorize_callback', :controller => 'dropbox'
    flow = DropboxOAuth2Flow.new(APP_KEY, APP_SECRET, redirect_url, session, :dropbox_auth_csrf_token)
    return flow
  end

  def connect
    if session[:access_token] then redirect_to url_for :action => 'index' end
  end

  def authorize
    flow = get_flow()
    authorize_url = get_flow().start()
    redirect_to authorize_url, status: 302
  end

  def authorize_callback
    flow = get_flow()
    session[:access_token], session[:user_id] = flow.finish(request.GET)
    redirect_to url_for :controller => 'dropbox'
  end
end
