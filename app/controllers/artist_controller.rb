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
          puts @artist.to_json
          @head.merge!({
              title: "#{@artist.name} | AlleSongs",
              description: "Listen #{@artist.name}'s complete discography, playlists, events, biography, lyrics and more online and free.",
              url: artist_custom_url(@artist.name),
              image: (@artist.images.present? ? @artist.images['extralarge'] : '')
          })

          @head[:title] = "#{params[:play]} - #{@head[:title]}"  if params[:play].present?
          @head[:url] = "#{@head[:url]}?play=#{params[:play]}"  if params[:play].present?
        elsif params[:angular].blank?
          url = custom_artist_name(params[:artist])
          url += "?play=#{params[:play]}" if params[:play].present?
          redirect_to "/#/#{url}"
        end

      end
      format.json {render json: @artist}
    end

  end

  def show
  end
end
