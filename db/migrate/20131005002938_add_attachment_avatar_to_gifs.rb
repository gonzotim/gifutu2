class AddAttachmentAvatarToGifs < ActiveRecord::Migration
  def self.up
    change_table :gifs do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :gifs, :avatar
  end
end
