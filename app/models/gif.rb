class Gif < ActiveRecord::Base



	acts_as_taggable

	has_attached_file :avatar, :styles => { :thumb => ["100x100", :jpg] },
    	:default_url => 'missing_image.jpg',
    	:storage => :s3,
		:s3_credentials => {
			:bucket => ENV['AWS_BUCKET'],
			:access_key_id => ENV['AWS_ACCESS_KEY_ID'],
			:secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
		},
    	:path => ":attachment/:id/:style.:extension"

	def avatar_remote_url(url_value)
	    uri = URI(url_value)
	    path = uri.path 
	    pathname = Pathname.new(path)
	    extension = pathname.extname # gif
	    if ['.jpeg', '.jpg','.png', '.gif'].include? extension
	      self.avatar = URI.parse(url_value)
	    	@avatar_remote_url = url_value
	    end
	end

	def self.fetch_gif_and_next(gifdex, position)
    	@gif = Gif.find(gifdex[position])
    	@next_gif = Gif.find(gifdex[position + 1])

    	return [@gif,@next_gif]
	end

end
