require 'open-uri'

class HomeController < ApplicationController

  layout 'home'

  before_action do
    if cookies[:latest_artist] && !session[:auto_redirected]
      session[:auto_redirected] = true
      redirect_to artist_custom_path(cookies[:latest_artist])
    end
  end

  def index
    #@img_url = "http://s2.vagalume.com"
    #@artists = JSON.parse(open("http://www.vagalume.com.br/api/rank.php?type=art&period=month&scope=all&limit=80").read)['art']['month']['all']
    #@artists = Artist.order('created_at asc').limit(80)

    Rockstar.lastfm = {:api_key => "534b78cd8e40fe67e31b50b9693ae512", :api_secret => "abc7b7049ad4e653783023075ca14e73"}
    geo = Rockstar::Geo.new
    @artists = geo.topartists('brasil', 18)
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
