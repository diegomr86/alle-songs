require 'open-uri'
class PlayerController < ApplicationController

  layout 'ajax'

  YOUTUBE_CLIENT = YouTubeIt::Client.new(:dev_key => "AI39si6ht3fhDpGzdgYtBGP2UF0baH4o_6QRnQj-e4f2EkWjyrHfaYMphbKdmqEjjHJg7bLEnitHlO1PMHdw6xAlXMUUsTTgpQ")
  def index
    if params[:music]

      @music_info = JSON.parse(open("http://www.vagalume.com.br/api/search.php?art=#{URI::escape(params[:artist])}&mus=#{URI::escape(params[:music])}&extra=alb").read)

      @musics = YOUTUBE_CLIENT.videos_by(:query => '"'+params[:artist]+' - '+params[:music]+ '"', :categories => [:music], page: params[:page], :per_page => 4).videos
      @music = @musics.first
    end

    respond_to do |format|
      format.html
      format.json {render json: @musics}
    end
  end
end
