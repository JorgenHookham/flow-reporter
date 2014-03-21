class SetupController < ApplicationController
  def index
    if !session[:access_token]
      redirect_to url_for :action => 'connect', :controller => 'dropbox'
    elsif !session[:reporter]
      redirect_to url_for :action => 'reporter', :controller => 'dropbox'
    else
      redirect_to url_for :controller => 'flow'
    end
  end
end
