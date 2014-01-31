class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.string :bookmark_type
      t.references :user, index: true
      t.string :value
      t.string :cover

      t.timestamps
    end
  end
end
