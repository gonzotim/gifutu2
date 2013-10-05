class Gif < ActiveRecord::Base
	has_attached_file :avatar, :styles => { :thumb => "200x200" },
    	:default_url => 'missing_image.jpg',
    	:storage => :s3,
		:s3_credentials => {
			:bucket => ENV['AWS_BUCKET'],
			:access_key_id => ENV['AWS_ACCESS_KEY_ID'],
			:secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
		},
    	:path => ":attachment/:id/:style.:extension"

    #attr_accessible :caption, :downvotes, :upvotes, :avatar, :image_url
end
