class Import < ActiveRecord::Base
	include HTTParty
  	base_uri 'http://reddit.com'

	def self.fetch_gif_from_reddit(sort, t, limit)
		response = get("/r/gifs/search/.json?sort=#{sort}&restrict_sr=on&t=#{t}&limit=#{limit}")
		return response
	end
end
