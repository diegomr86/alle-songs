# encoding: UTF-8

require 'open-uri'

class AlbumController < ApplicationController

  before_action :rockstar_init

  def index

    # @album = Rockstar::Album.new(params[:artist], params[:album], :include_info => true)
    #
    # respond_to do |format|
    #   format.html
    #   format.json {render json: @album}
    # end

  end

  def show
    puts params[:id]
  end
end
