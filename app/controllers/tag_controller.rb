class TagController < ApplicationController

  def show
    respond_to do |format|
      format.html do
        if is_bot?
          @tag = Rockstar::Tag.new(params[:id])
          @head.merge!({
                           title: "The best of #{@tag.name} | AlleSongs",
                           description: "Listen the best of #{@tag.name} with artists, albums, playlists, events, biography, lyrics and more online and free.",
                           url: tag_url(custom_artist_name(@tag.name)),
                           image: (@tag.top_artists.present? ? @tag.top_artists[0].images['extralarge'] : '')
                       })

        elsif params[:angular].blank?
          redirect_to "/#/tag/#{custom_artist_name(params[:id])}"
        end

      end
    end
  end
end
