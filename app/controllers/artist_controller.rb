require 'open-uri'

class ArtistController < ApplicationController


  def index

    @img_url = "http://s2.vagalume.com"


    s = JSON.parse(open("http://www.vagalume.com.br/api/search.php?art=#{URI::escape(params[:artist])}").read) if params[:artist].present?

    if s.present? && s["art"].present?
      @url = s["art"]["url"]
      @artist = JSON.parse(open("#{@url}/index.js").read)["artist"]
      @discography = JSON.parse(open("#{@url}/discografia/index.js").read)["discography"]
      @genres = @artist['genre'].collect{|g| g['name']}
    else
      @artists = JSON.parse(open("http://www.vagalume.com.br/api/rank.php?type=art&period=month&scope=translations&limit=200").read)['art']['month']['all']
    end

    respond_to do |format|
      format.html
      format.json {render json: @discography}
      format.xml {render :xml => @artist}
    end
  end
end
