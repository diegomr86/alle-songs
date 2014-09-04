module RockstarHelper
  def rockstar_init
    Rockstar.lastfm = {:api_key => "534b78cd8e40fe67e31b50b9693ae512", :api_secret => "abc7b7049ad4e653783023075ca14e73"}
  end
  def search_artist(query)
    rockstar_init
    @artists = Rockstar::Artist.new(query).search
    end

  def autocomplete(query)
    res = JSON.parse(open("http://www.lastfm.com.br/search/autocomplete?q=ir").read)['response']['docs']
    { artists: res.select { |a| a['restype'] == 6 },
      albums: res.select { |a| a['restype'] == 8 },
      tracks: res.select { |a| a['restype'] == 9 },
      tags: res.select { |a| a['restype'] == 32 }
    }

  end

end
