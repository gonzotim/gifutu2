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

    	gifs.first(3).each do |gif|
    		puts gif
    		@gif = Gif.new #first_or_create(image_url: gif["image_url"])
    		@gif.caption = gif["caption"]
    		puts "caption " + @gif.caption

    		@gif.url = gif["image_url"]
    		puts "url " + @gif.url.to_s
    	    if @gif.url != ""
    	    	@gif.avatar_remote_url(@gif.url)	
    	    end
	  		@gif.upvotes = gif["upvotes"].to_i + gif["liked"].to_i
	  		puts "upvotes " + @gif.upvotes.to_s
	  		@gif.downvotes = gif["downvotes"].to_i + gif["disliked"].to_i
	  		puts "downvotes " + @gif.downvotes.to_s
	  		@gif.views = gif["upvotes"].to_i + gif["liked"].to_i + gif["downvotes"].to_i + gif["disliked"].to_i
	  		puts "views " + @gif.views.to_s

	  		puts "board name" + gif["board_id"]["name"].to_s
	  		@gif.tag_list = gif["board_id"]["name"]

	  		@gif.description = gif["description"].to_s
	  		puts "description " + @gif.description.to_s


	  		if @views != 0 || @gif.downvotes == 0

	  			puts "upvote " + @gif.upvotes.to_i.to_s
	  			puts "downvote" +  ( @gif.upvotes.to_i + @gif.downvotes.to_i + 1).to_s
	  			@gif.ratio = @gif.upvotes.to_i / ( @gif.upvotes.to_i + @gif.downvotes.to_i + 1).to_f
	  			puts "ratio " + @gif.ratio.to_s
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
