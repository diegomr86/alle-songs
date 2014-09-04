class AddDurationToTrack < ActiveRecord::Migration
  def up
    add_column :tracks, :duration, :string
  end

  def down
    remove_column :tracks, :duration
  end
end
