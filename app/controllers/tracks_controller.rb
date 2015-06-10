class TracksController < ApplicationController
  respond_to :json

  before_action :set_track, only: [:show, :edit, :update, :destroy]

  def index
    @tracks = Track.order(params[:order] || "RANDOM()").paginate(:page => params[:page], :per_page => params[:per_page] || 20)
    respond_with(@tracks)
  end

  def show
    if @track = Track.find(params[:id])

      @music_info = JSON.parse(open("http://www.vagalume.com.br/api/search.php?art=#{URI::escape(@track.artist)}&mus=#{URI::escape(@track.name)}&extra=alb,ytid").read)
    end

    respond_to do |format|
      format.json {render json: {info: @music_info}}
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
