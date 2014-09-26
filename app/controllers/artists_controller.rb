class ArtistsController < ApplicationController
  respond_to :json

  before_action :set_artist, only: [:show, :edit, :update, :destroy]

  YOUTUBE_CLIENT = YouTubeIt::Client.new(:dev_key => "AI39si6ht3fhDpGzdgYtBGP2UF0baH4o_6QRnQj-e4f2EkWjyrHfaYMphbKdmqEjjHJg7bLEnitHlO1PMHdw6xAlXMUUsTTgpQ")


  def index
    @artists = Artist.order("RANDOM()").paginate(:page => params[:page], :per_page => 12)
    respond_with(@artists)
  end

  def show
    @artist = Artist.find(params[:id])
    respond_with(@artist)
  end

  def new
    @artist = Artist.new
  end

  def edit
  end

  def create
    @artist = Artist.new(artist_params)

    respond_to do |format|
      if @artist.save
        format.html { redirect_to @artist, notice: 'Artist was successfully created.' }
        format.json { render action: 'show', status: :created, location: @artist }
      else
        format.html { render action: 'new' }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @artist.update(artist_params)
        format.html { redirect_to @artist, notice: 'Artist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @artist.destroy
    respond_to do |format|
      format.html { redirect_to artists_url }
      format.json { head :no_content }
    end
  end

  private
    def set_artist
      @artist = Artist.find(params[:id])
    end

    def artist_params
      params.require(:artist).permit(:name, :artist, :picture, :code)
    end
end