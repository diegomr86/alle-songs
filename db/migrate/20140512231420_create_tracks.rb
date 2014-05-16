class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :track
      t.string :artist
      t.string :session_id

      t.timestamps
      t.index :session_id
    end

  end
end
