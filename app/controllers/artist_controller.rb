# encoding: UTF-8

require 'open-uri'

class ArtistController < ApplicationController

  layout false

  before_action :rockstar_init

  def index
    puts params
    puts params[:artist]
    @artist = Rockstar::Artist.new(params[:artist], :include_info => true) if params[:angular].blank?

    respond_to do |format|
      format.html
      format.json {render json: @artist}
    end

  end

  def show
    puts params[:id]
  end
end
