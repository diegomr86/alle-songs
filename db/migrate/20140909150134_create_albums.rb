class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :artist
      t.string :name
      t.string :code
      t.string :picture

      t.timestamps
    end
  end
end
