class AddSessionIdToPlaylist < ActiveRecord::Migration
  def change

    add_column :playlists, :session_id, :string

    remove_column :playitems, :user_id
    remove_column :playitems, :session_id
    remove_column :tracks, :session_id

  end
end
