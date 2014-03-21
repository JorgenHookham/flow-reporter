require 'dropbox_sdk'

class DropboxController < ApplicationController
  APP_KEY = 'ujdsycik761l86k'
  APP_SECRET = 't8tqmjuu7s1bnud'

  def index
    if !session[:access_token]
      redirect_to url_for :controller => 'setup'
    end
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
    redirect_to url_for :controller => 'setup'
  end

  def reporter
    client = DropboxClient.new(session[:access_token])
    if client.metadata('/Apps/Reporter-App')
      session[:reporter] = true
      redirect_to url_for :controller => 'setup'
    end
  end

  def get_files
    client = DropboxClient.new(session[:access_token])
    files = []
    for file_meta in client.metadata('/Apps/Reporter-App')["contents"]
      files << client.get_file(file_meta["path"])
    end
    return files
  end

  def get_snapshots
    snapshots = []
    for file in get_files()
      for snapshot in JSON.parse(file)["snapshots"]
        snapshots << snapshot
      end
    end
    return snapshots
  end

  def get_responses
    responses = []
    for snapshot in get_snapshots()
      for response in snapshot["responses"]
        responses << response
      end
    end
    return responses
  end

  def list_files
    @files = get_files()
  end

  def list_snapshots
    @snapshots = get_snapshots()
  end

  def list_responses
    @responses = get_responses()
  end
end
