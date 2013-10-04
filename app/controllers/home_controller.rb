require 'open-uri'

class HomeController < ApplicationController

  layout 'home'

  def index

    @img_url = "http://s2.vagalume.com"
    @artists = JSON.parse(open("http://www.vagalume.com.br/api/rank.php?type=art&period=month&scope=translations&limit=84").read)['art']['month']['all']

    respond_to do |format|
      format.html
      format.json {render json: @artists}
    end
  end
end
