namespace :ingest do
	ActiveSupport::Deprecation.silenced = true

	task :index => :environment do
		puts "running set_populate_iteration"
		@gifs = Gif.all
		@gifs.each do |gif|
			puts (gif.id.to_s + ", " + gif.caption)
		end
	end

	task :initalize_gifs => :environment do
		puts "intializing gifs"
		@gifs = Gif.all
		@gifs.each do |gif|
			gif.approved = true
			gif.deleted = false
			gif.save
		end
	end

	task :reddit => :environment do
		puts "Ingest: Reddit"
		api_response = Gif.fetch_gif_from_reddit("hot", "day", 20)
		#puts api_response
		@saved_counter = 0
		@failed_counter = 0
		api_response["data"]["children"].each do |result|
			#puts result
			puts result["data"]["url"].to_s
			gif = Gif.new
			gif.caption = result["data"]["title"]
			puts "caption " + gif.caption
			gif.approved = false
			gif.deleted = false
			gif.url = result["data"]["url"]

			puts "gif " + Gif.where("url = ?", gif.url).count.to_s
			next if Gif.where("url = ?", gif.url).count != 0


			if gif.url.include? ("http://imgur.com/")
				imgur_ref = gif.url
				imgur_ref.slice! "http://imgur.com/"
				puts "image is an imgur page. Ref: #{imgur_ref} "
				gif.url = "http://i.imgur.com/" + imgur_ref + ".jpg"
			end

			gif.avatar_remote_url(gif.url)

			if gif.save
				puts "image #{gif.id.to_s} saved."
				@saved = true
				@saved_counter = @saved_counter + 1
			else
				puts "image #{gif.id.to_s} failed. url is #{gif.url}"
				@gif.errors.full_messages.each do |msg|
	    			puts "message #{msg}"
				end
				@saved = false
				@failed_counter = @failed_counter + 1
			end


		end

		puts @saved_counter.to_s + " saved gifs"
		puts @failed_counter.to_s + " failed gifs"

	end

	task :fetch_gifs => :environment do
    	gifs = GifutuImport.fetch_gifs()
    	@gifs = Gif.delete_all()

    	gifs.each do |gif|
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

	  		@gif.approved = false
			@gif.deleted = false


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
