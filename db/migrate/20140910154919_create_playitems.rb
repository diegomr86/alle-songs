class CreatePlayitems < ActiveRecord::Migration
  def change
    create_table :playitems do |t|
      t.string :name
      t.string :artist
      t.string :picture
      t.string :duration
      t.string :session_id
      t.integer :user_id
      t.integer :playlist_id

      t.index :user_id
      t.index :playlist_id
      t.timestamps
    end
  end
end
