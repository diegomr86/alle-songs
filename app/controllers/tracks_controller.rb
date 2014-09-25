class TracksController < ApplicationController
  respond_to :json

  before_action :set_track, only: [:show, :edit, :update, :destroy]

  YOUTUBE_CLIENT = YouTubeIt::Client.new(:dev_key => "AI39si6ht3fhDpGzdgYtBGP2UF0baH4o_6QRnQj-e4f2EkWjyrHfaYMphbKdmqEjjHJg7bLEnitHlO1PMHdw6xAlXMUUsTTgpQ")


  def index
    @tracks = Track.order(params[:order] || "RANDOM()").paginate(:page => params[:page], :per_page => params[:per_page] || 20)
    respond_with(@tracks)
  end

  def show
    if @track = Track.find(params[:id])

      @music_info = JSON.parse(open("http://www.vagalume.com.br/api/search.php?art=#{URI::escape(@track.artist)}&mus=#{URI::escape(@track.name)}&extra=alb,ytid").read)
      query =  "#{@track.artist} - #{@track.name}"
      videos = YOUTUBE_CLIENT.videos_by(:query => '"'+query+ '"', :categories => [:music], page: params[:page], :per_page => 4).videos
      videos.each do |video|
        puts video.title
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
    @track = Track.new
  end

  def edit
  end

  def create
    @track = Track.new(track_params)

    respond_to do |format|
      if @track.save
        format.html { redirect_to @track, notice: 'Track was successfully created.' }
        format.json { render action: 'show', status: :created, location: @track }
      else
        format.html { render action: 'new' }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @track.update(track_params)
        format.html { redirect_to @track, notice: 'Track was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @track.destroy
    respond_to do |format|
      format.html { redirect_to tracks_url }
      format.json { head :no_content }
    end
  end

  private
    def set_track
      @track = Track.find(params[:id])
    end

    def track_params
      params.require(:track).permit(:name, :artist, :picture, :duration, :session_id)
    end
end
