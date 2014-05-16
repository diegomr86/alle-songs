module RockstarHelper
  def rockstar_init
    Rockstar.lastfm = {:api_key => "534b78cd8e40fe67e31b50b9693ae512", :api_secret => "abc7b7049ad4e653783023075ca14e73"}
  end
  def search_artist(query)
    rockstar_init
    @artists = Rockstar::Artist.new(query).search
  end
end
