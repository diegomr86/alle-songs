class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name
      t.string :code
      t.string :picture

      t.timestamps
    end
  end
end
