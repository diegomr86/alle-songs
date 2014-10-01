class PlayitemsController < ApplicationController
  respond_to :json

  before_action :set_playitem, only: [:show, :edit, :update, :destroy]

  YOUTUBE_CLIENT = YouTubeIt::Client.new(:dev_key => "AI39si6ht3fhDpGzdgYtBGP2UF0baH4o_6QRnQj-e4f2EkWjyrHfaYMphbKdmqEjjHJg7bLEnitHlO1PMHdw6xAlXMUUsTTgpQ")


  def index
    @playitems = Playitem.where(playlist_id: params[:playlist_id]).order("created_at asc")
    respond_with(@playitems)
  end

  def show
    if @playitem = Playitem.find(params[:id])
      p @playitem.to_json

      @music_info = JSON.parse(open("http://www.vagalume.com.br/api/search.php?art=#{URI::escape(@playitem.artist)}&mus=#{URI::escape(@playitem.name)}&extra=alb,ytid").read)
      query =  "#{@playitem.artist} - #{@playitem.name}"
      videos = YOUTUBE_CLIENT.videos_by(:query => '"'+query+ '"', :categories => [:music], page: params[:page], :per_page => 4).videos
      videos.each do |video|
        video_id = video.unique_id if video.title == query
        break
      end
      video_id = videos.first.unique_id if video_id.blank? && videos.first
    end

    respond_to do |format|
      format.json {render json: {info: @music_info, video: video_id}}
    end
  end

  def new
    @playitem = Playitem.new
  end

  def edit
  end

  def create
    @playitem = Playitem.new(playitem_params)

    respond_to do |format|
      if @playitem.save
        format.html { redirect_to @playitem, notice: 'Playitem was successfully created.' }
        format.json { render action: 'show', status: :created, location: @playitem }
      else
        format.html { render action: 'new' }
        format.json { render json: @playitem.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @playitem.update(playitem_params)
        format.html { redirect_to @playitem, notice: 'Playitem was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @playitem.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @playitem.destroy
    respond_to do |format|
      format.html { redirect_to playitems_url }
      format.json { head :no_content }
    end
  end

  private
    def set_playitem
      @playitem = Playitem.find(params[:id])
    end

    def playitem_params
      params.require(:playitem).permit(:name, :artist, :picture, :duration, :playlist_id)
    end
end
