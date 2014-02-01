class BookmarksController < ApplicationController
  before_action :set_bookmark, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!

  layout 'ajax'

  def index
    @bookmarks = current_user.bookmarks.all
  end

  def show
  end

  def new
    @bookmark = current_user.bookmarks.new(bookmark_type: :artist, value: params[:artist][:name], cover: params[:artist][:cover])

  end

  def edit
  end

  def create
    @bookmark = current_user.bookmarks.new(bookmark_params)

    respond_to do |format|
      if @bookmark.save
        format.html { redirect_to @bookmark }
        format.json { render action: 'show', status: :created, location: @bookmark }
      else
        format.html { render action: 'new' }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @bookmark.update(bookmark_params)
        format.html { redirect_to @bookmark }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    value = @bookmark.value
    cover = @bookmark.cover

    @bookmark.destroy

    @bookmark = current_user.bookmarks.new(bookmark_type: :artist, value: value, cover: cover)

    respond_to do |format|
      format.html { render action: 'new' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookmark
      @bookmark = current_user.bookmarks.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bookmark_params
      params.require(:bookmark).permit(:bookmark_type, :user_id, :value, :cover)
    end
end
