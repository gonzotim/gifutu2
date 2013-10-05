class CreateGifs < ActiveRecord::Migration
  def change
    create_table :gifs do |t|
      t.text :caption
      t.string :url
      t.integer :upvotes
      t.integer :downvotes
      t.integer :views
      t.float :ratio
      t.text :avatar_meta
      t.text :description




      t.timestamps
    end
  end
end
