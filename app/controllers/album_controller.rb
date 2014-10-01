# encoding: UTF-8

require 'open-uri'

class AlbumController < ApplicationController

  def index

    respond_to do |format|
      format.html do
        if is_bot?
          @album = Rockstar::Album.new(params[:artist], params[:album], :include_info => true)
        elsif params[:angular].blank?
          redirect_to "/#/#{custom_artist_name(params[:artist])}/#{custom_artist_name(params[:album])}"
        end

      end
    end

  end

  def show
    puts params[:id]
  end
end
