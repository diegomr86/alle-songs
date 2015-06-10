class PlayitemsController < ApplicationController
  respond_to :json

  before_action :set_playitem, only: [:show, :edit, :update, :destroy]

  before_action do
    Yt.configure do |config|
      config.api_key = 'AIzaSyCQvtuIjzIRPUgB09R_geCTvqLMTvFItUQ'
    end
  end

  def index
    @playitems = Playitem.where(playlist_id: params[:playlist_id]).order("created_at asc")
    respond_with(@playitems)
  end

  def show

    yt =

    if @playitem = Playitem.find(params[:id])
      p @playitem.to_json

      @music_info = JSON.parse(open("http://www.vagalume.com.br/api/search.php?art=#{URI::escape(@playitem.artist)}&mus=#{URI::escape(@playitem.name)}&extra=alb,ytid").read)
      query =  "#{@playitem.artist} - #{@playitem.name}"
      videos = Yt::Collections::Videos.new.where(:q=> '"'+query+ '"', page: params[:page], :per_page => 4, video_category_id: 10)
      videos.each do |video|
        video_id = video.id if video.title == query
        break
      end
      video_id = videos.first.id if video_id.blank? && videos.first
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
