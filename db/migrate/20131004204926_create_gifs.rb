class CreateGifs < ActiveRecord::Migration
  def change
    create_table :gifs do |t|
      t.text :caption
      t.integer :upvotes
      t.integer :downvotes
      t.integer :views
      t.integer :ratio

      t.timestamps
    end
  end
end
