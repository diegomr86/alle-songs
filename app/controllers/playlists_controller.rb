class PlaylistsController < ApplicationController

  respond_to :json

  before_action :set_playlist, only: [:show, :edit, :destroy]
  before_action :authenticate_user!, only: [:index, :create, :new, :update, :destroy]


  def index
    @playlists = user_playlists
    respond_with(@playlists)
  end

  def show
    @playlist = Playlist.where('id = ? or session_id = ? or ', params[:id])

    respond_to do |format|
      format.json {render json: @playlist }
    end
  end

  def default
    @playlist = Playlist.find_or_create_by(session_id: request.session_options[:id])

    respond_to do |format|
      format.json {render json: @playlist }
    end
  end

  def load
    current_playlist = Playlist.find(params[:current_playlist])

    current_playlist.playitems.destroy_all

    Playlist.find(params[:id]).playitems.each do |playitem|
      puts current_playlist.playitems.create(playitem.attributes.except('id', 'playlist_id'))
    end

    @playitems = current_playlist.playitems

    respond_to do |format|
      format.json { render action: :load }
    end
  end

  def new
    @playlist = current_user.playlists.new
  end

  def edit
  end

  def create
    @playlist = current_user.playlists.new(playlist_params)

    respond_to do |format|
      if @playlist.save
        Playlist.find(params[:current_playlist]).playitems.each do |playitem|
          puts @playlist.playitems.create(playitem.attributes.except('id', 'playlist_id'))
        end
        format.html { redirect_to @playlist, notice: 'Playlist was successfully created.' }
        format.json { render action: 'show', status: :created, location: @playlist }
      else
        format.html { render action: 'new' }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @playlist = current_user.playlists.find(params[:id])

    respond_to do |format|
      if @playlist.update(playlist_params)
        puts playlist_params
        format.html { redirect_to @playlist, notice: 'Playlist was successfully updated.' }
        format.json { render json: user_playlists }
      else
        format.html { render action: 'edit' }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @playlist = current_user.playlists.find(params[:id])

    @playlist.destroy

    respond_to do |format|
      format.html { redirect_to playlists_url }
      format.json { head :no_content }
    end
  end

  private
    def user_playlists
      current_user.playlists.order("created_at desc").includes(:playitems)
    end

    def set_playlist
      @playlist = Playlist.find(params[:id])
    end

    def playlist_params
      params.require(:playlist).permit(:name, :artist, :picture, :duration, :session_id, :user_id)
    end
end
