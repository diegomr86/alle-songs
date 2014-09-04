class ChangeTrackNameColumn < ActiveRecord::Migration
  def change
    rename_column :tracks, :track, :name
  end
end
