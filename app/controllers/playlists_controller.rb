class PlaylistsController < ApplicationController
  respond_to :json

  before_action :set_playlist, only: [:show, :edit, :update, :destroy]


  def index
    if user_signed_in?
      @playlists = current_user.playlists.order("created_at desc").includes(:playitems)
    else
      @playlists = Playlist.where(session_id: request.session_options[:id])
    end
    respond_with(@playlists)
  end

  def show
    @playlist = Playlist.where('id = ? or session_id = ? or ', params[:id])

    respond_to do |format|
      format.json {render json: @playlist }
    end
  end

  def default
    if user_signed_in?
      @playlist = current_user.playlists.find_or_create_by(name: 'Default playlist')
    else
      @playlist = Playlist.find_or_create_by(session_id: request.session_options[:id], name: 'Default playlist')
    end

    respond_to do |format|
      format.json {render json: @playlist }
    end
  end

  def new
    @playlist = Playlist.new
  end

  def edit
  end

  def create
    @playlist = Playlist.new(playlist_params)

    respond_to do |format|
      if @playlist.save
        format.html { redirect_to @playlist, notice: 'Playlist was successfully created.' }
        format.json { render action: 'show', status: :created, location: @playlist }
      else
        format.html { render action: 'new' }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @playlist.update(playlist_params)
        format.html { redirect_to @playlist, notice: 'Playlist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @playlist.destroy
    respond_to do |format|
      format.html { redirect_to playlists_url }
      format.json { head :no_content }
    end
  end

  private
    def set_playlist
      @playlist = Playlist.find(params[:id])
    end

    def playlist_params
      params.require(:playlist).permit(:name, :artist, :picture, :duration, :session_id, :user_id)
    end
end
