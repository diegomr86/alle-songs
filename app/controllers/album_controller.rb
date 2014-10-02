# encoding: UTF-8

require 'open-uri'

class AlbumController < ApplicationController

  def index

    respond_to do |format|
      format.html do
        if is_bot?
          @album = Rockstar::Album.new(params[:artist], params[:album], :include_info => true)
          @head.merge!({
               title: "#{@album.name} - #{@album.artist} | AlleSongs",
               description: "Enjoy #{@album.name}, many other #{@album.artist} albums, playlists, events, biography, lyrics and more online and free.",
               url: artist_album_root_url(custom_artist_name(@album.artist), custom_artist_name(@album.name)),
               image: @album.images['extralarge']
           })

        elsif params[:angular].blank?
          redirect_to "/#/#{custom_artist_name(params[:artist])}/#{custom_artist_name(params[:album])}"
        end

      end
    end

  end

  def show
  end
end
