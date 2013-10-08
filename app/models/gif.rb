class Gif < ActiveRecord::Base
	acts_as_taggable
	rolify

  	has_attached_file :avatar, :styles => { :thumb => ["100x100", :jpg], :facebook => ["90x90", :jpg] },
    	:default_url => 'missing_image.jpg',
    	:storage => :s3,
		:s3_credentials => {
			:bucket => ENV['AWS_BUCKET'],
			:access_key_id => ENV['AWS_ACCESS_KEY_ID'],
			:secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
		},
    	:path => ":attachment/:id/:style.:extension"

  	validates :url, presence: true
  	validates_attachment_content_type :avatar, :content_type => ['image/gif']

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
		puts "gifdex: " + gifdex.to_s
		puts "position: " + position.to_s
		if !defined?(position)
			#puts "defined"
			position = 0
		end
    	@gif = Gif.find(gifdex[position])
    	if gifdex.length == position + 1
    		@next_gif = nil
    	else
    		@next_gif = Gif.find(gifdex[position + 1])
    	end
    	return [@gif,@next_gif]
	end




end
