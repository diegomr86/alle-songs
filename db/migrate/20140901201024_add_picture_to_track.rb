class AddPictureToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :picture, :string
  end
end
