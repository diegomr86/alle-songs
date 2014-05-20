require 'open-uri'

class HomeController < ApplicationController

  layout 'home'

  before_action do

    rockstar_init

    if cookies[:latest_artist] && !session[:auto_redirected]
      session[:auto_redirected] = true
      redirect_to artist_custom_path(cookies[:latest_artist])
    end
  end

  def index

    @artists = Rockstar::Geo.new.topartists('brasil', 12)
    @tracks = Rockstar::Geo.new.toptracks('brazil', 10)

    respond_to do |format|
      format.html
      format.json {render json: @artists}
    end
  end

  def create

    Artist.import(params[:file])

    redirect_to root_url, notice: "Artists imported."

  end

end
