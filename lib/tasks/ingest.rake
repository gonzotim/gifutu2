namespace :ingest do
	puts ".populate 0.1"

	task :index => :environment do
		puts "running set_populate_iteration"
		@gifs = Gif.all
		@gifs.each do |gif|
			puts (gif.id.to_s + ", " + gif.caption)
		end
	end

	task :fetch_gifs => :environment do
    	gifs = GifutuImport.fetch_gifs()
    	@gifs = Gif.delete_all()

    	gifs.each do |gif|
    		
    		@gif = Gif.new #first_or_create(image_url: gif["image_url"])
    		@gif.caption = gif["caption"]
    		puts "caption " + @gif.caption
	  		@gif.upvotes = gif["upvotes"].to_i + gif["liked"].to_i
	  		puts "upvotes " + @gif.upvotes.to_s
	  		@gif.downvotes = gif["downvotes"].to_i + gif["disliked"].to_i
	  		puts "downvotes " + @gif.downvotes.to_s
	  		@gif.views = gif["upvotes"].to_i + gif["liked"].to_i + gif["downvotes"].to_i + gif["disliked"].to_i
	  		puts "views " + @gif.views.to_s
	  		if @views != 0 || @gif.downvotes == 0
	  			@gif.ratio = @gif.upvotes.to_i / ( @gif.upvotes.to_i + @gif.downvotes.to_i + 1)
	  			if @gif.save!
	  				puts @gif.id.to_s + " saved"
	  			else
	  				puts "save failed"
	  			end
	  		else
	  			puts "no views - skipping!"
	  		end

    	end
    end


end
