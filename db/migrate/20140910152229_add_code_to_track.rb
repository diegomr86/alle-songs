class AddCodeToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :code, :string
  end
end
