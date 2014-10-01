# encoding: UTF-8

require 'open-uri'

class ArtistController < ApplicationController

  def index

    respond_to do |format|
      format.html do
        puts "asaaaaaaaaaaaasaaaaaaaaaaaasaaaaaaaaaaaasaaaaaaaaaaaasaaaaaaaaaaaasaaaaaaaaaaaasaaaaaaaaaaaasaaaaaaaaaaaasaaaaaaaaaaaasaaaaaaaaaaaasaaaaaaaaaaaasaaaaaaaaaaaasaaaaaaaaaaa"
        puts is_bot?
        if is_bot?
          @artist = Rockstar::Artist.new(params[:artist], :include_info => true)
          @page_title = "#{@artist.name} on AlleSongs"
          @page_description = "#{@page_description}"

        elsif params[:angular].blank?
          redirect_to "/#/#{custom_artist_name(params[:artist])}"
        end

      end
      format.json {render json: @artist}
    end

  end

  def show
  end
end
