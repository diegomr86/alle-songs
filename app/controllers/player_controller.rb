# encoding: UTF-8

require 'open-uri'
class PlayerController < ApplicationController

  layout 'ajax'

  YOUTUBE_CLIENT = YouTubeIt::Client.new(:dev_key => "AI39si6ht3fhDpGzdgYtBGP2UF0baH4o_6QRnQj-e4f2EkWjyrHfaYMphbKdmqEjjHJg7bLEnitHlO1PMHdw6xAlXMUUsTTgpQ")
  def index
    if params[:music]

      @music_info = JSON.parse(open("http://www.vagalume.com.br/api/search.php?art=#{URI::escape(params[:artist])}&mus=#{URI::escape(params[:music])}&extra=alb,ytid").read)
      if @music_info['mus'].present? && @music_info['mus'][0].present? && @music_info['mus'][0]['ytid'].present?
        video_id = @music_info['mus'][0]['ytid']
      else
        query =  "#{params[:artist]} - #{params[:music]}"
        videos = YOUTUBE_CLIENT.videos_by(:query => '"'+query+ '"', :categories => [:music], page: params[:page], :per_page => 4).videos
        videos.each do |video|
          puts video.title
          video_id = video.unique_id if video.title == query
          break
        end
        video_id = videos.first.unique_id if video_id.blank? && videos.first
      end
    end

    respond_to do |format|
      format.html do
        redirect_to root_path, notice: 'Página não encontrada'
      end
      format.json {render json: {info: @music_info, video: video_id}}
    end
  end
end
