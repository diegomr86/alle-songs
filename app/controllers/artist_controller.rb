# encoding: UTF-8

require 'open-uri'

class ArtistController < ApplicationController

  layout 'home'

  before_action :rockstar_init

  def index

    @artist = Rockstar::Artist.new(params[:artist], :include_info => true)

    respond_to do |format|
      format.html
      format.json {render json: [@discography, @artist]}
      format.xml {render :xml => @artist}
    end

  end

  def show

  end
end
