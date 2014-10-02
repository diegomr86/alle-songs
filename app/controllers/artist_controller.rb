# encoding: UTF-8
class ArtistController < ApplicationController

  def index

    respond_to do |format|
      format.html do
        puts "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
        puts is_bot?.to_s
        puts request.user_agent
        if is_bot?
          @artist = Rockstar::Artist.new(params[:artist], :include_info => true)

          @head.merge!({
              title: "#{@artist.name} | AlleSongs",
              description: "Enjoy #{@artist.name}'s discography, playlists, events, biography, lyrics and more online and free.",
              url: artist_custom_url(@artist.name),
              image: @artist.images['extralarge']
          })

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
