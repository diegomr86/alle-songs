class Playlist < ActiveRecord::Base
  belongs_to :user
  has_many :playitems

  def playitems_count
    playitems.count
  end
end
