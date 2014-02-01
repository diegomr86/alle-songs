class CreateBookmarks < ActiveRecord::Migration
  def up
    create_table :bookmarks do |t|
      t.string :bookmark_type
      t.references :user, index: true
      t.string :value
      t.string :cover

      t.timestamps
    end
  end

  def down
    drop_table :bookmarks
  end
end
