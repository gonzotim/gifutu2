namespace :ingest do
	puts ".populate 0.1"
	
  	#base_uri 'gifutu.com'

	task :index => :environment do
		include HTTParty
		puts "running set_populate_iteration"
		@gifs = Gif.all
		@gifs.each do |gif|
			puts (gif.id.to_s + ", " + gif.caption)
		end
		@gif = Gif.new
	end

	task :fetch_gifs => :environment do
		#include HTTParty
		#response = get("/gifs.json")
		#response = HTTParty.get('http://gifutu.com/gifs.json')
    	#puts response
    	#gifs = Array.new
    	gifs = GifutuImport.fetch_gifs()
    	#puts response
    	#@gif = Gif.new
#@gifs = Gif.all
    	

    	#puts "count" + response.count.to_s
    	@gifs = Gif.delete_all()
	  	#puts @gifs.count

    	gifs.each do |gif|
    		puts gif["caption"]
    		@gif = Gif.new#first_or_create(image_url: gif["image_url"])
    		@gif.caption = gif["caption"]
	  		@gif.upvotes = gif["upvotes"].to_i + gif["liked"].to_i
	  		puts "upvotes " + @gif.upvotes.to_s
	  		@gif.downvotes = gif["downvotes"].to_i + gif["disliked"].to_i
	  		puts "downvotes " + @gif.downvotes.to_s
	  		@gif.views = gif["upvotes"].to_i + gif["liked"].to_i + gif["downvotes"].to_i + gif["disliked"].to_i
	  		puts "views " + @gif.views.to_s
	  		if @views != 0 || @gif.downvotes == 0
	  			@gif.ratio = @gif.upvotes.to_i / ( @gif.upvotes.to_i + @gif.downvotes.to_i)
	  			if @gif.save!
	  				puts @gif.id.to_s + " saved"
	  			else
	  				puts "save failed"
	  			end
	  		else
	  			puts "no views - skipping!"
	  		end
	  		# @gif.caption = gif["caption"]
	  		# @gif.caption = gif["caption"]
	  		# @gif.caption = gif["caption"]
	  		#puts @gif


	  		@gifs = Gif.all
	  		#puts "no of gifs "+ @gifs.count
	  		 #      t.text :caption
      # t.integer :upvotes
      # t.integer :downvotes
      # t.integer :views
      # t.integer :ratio

    	end
    	#response.each do |gif|
    		#puts
      		#puts "hello " + gif["id"].to_s
      		#puts "hello " + gif["caption"].to_s
      		#puts "image_url "# + gif["image_url"].to_s
      		

    
      		#@gif = Gif.first_or_create(image_url: gif["image_url"])
      		#gif = Gif.new#where(:id => '1')#.first_or_create

      		#@gif.save

      		#@gif = Gif.new

      		#@gif = "Gif.new"

      		#make_gif()



      		#+ image["data"]
      		#reddit_images << self.new(image["data"]["title"].gsub(/\[.*\]/, ""), image["data"]["author"], image["data"]["url"])
    	#end
    end

    def make_gif()
    	puts "hell0"
    	@gif = Gif.new
    end

end
