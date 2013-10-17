namespace :ingest do
	ActiveSupport::Deprecation.silenced = true

	task :index => :environment do
		puts "running set_populate_iteration"
		@gifs = Gif.all
		@gifs.each do |gif|
			puts (gif.id.to_s + ", " + gif.ratio.to_s)
		end
	end

	task :calcs => :environment do
		puts "calculate views and ratio"
		@gifs = Gif.all
		@gifs.each do |gif|
			gif.views = gif.upvotes + gif.downvotes
			gif.ratio  = gif.upvotes.to_i / ( gif.upvotes.to_i + gif.downvotes.to_i + 1).to_f
			gif.save
			puts "gif " + gif.id.to_s + ", views " + gif.views.to_s + ", ratio " + gif.ratio.to_s

		end

		# highest_ratio = Gif.where(ratio: 0.01..1).maximum("ratio")
		# lowest_ratio = Gif.where(ratio: 0.01..1).minimum("ratio")

		# @gifs.each do |gif|
		# 	if gif.ratio != 0
		# 		puts "ratio " + gif.ratio.to_s
		# 		puts "highest_ratio  " + highest_ratio.to_s
		# 		puts "lowest_ratio  " + lowest_ratio.to_s
		# 		gif.ratio  = ((gif.ratio - lowest_ratio) / (highest_ratio - lowest_ratio)) * 100

		# 		gif.save
		# 		puts gif.ratio.to_s
		# 		puts
		# 	end
		# end
		# puts "most loved gif is " + Gif.all.order("ratio DESC").first.id.to_s
		# puts "most un-loved gif is " + Gif.all.order("ratio DESC").last.id.to_s
	end

	task :reddit => :environment do
		puts "Ingest: Reddit"
		api_response = Import.fetch_gif_from_reddit("hot", "day", 10)
		#puts api_response
		@saved_counter = 0
		@failed_counter = 0
		average_ratio = Gif.where('ratio != ?', 0).average('ratio')
		api_response["data"]["children"].each do |result|
			#puts result
			puts result["data"]["url"].to_s
			gif = Gif.new
			gif.caption = result["data"]["title"]
			puts "caption " + gif.caption
			gif.approved = false
			gif.deleted = false
			gif.upvotes = 0
			gif.downvotes = 0
			gif.ratio = average_ratio
			gif.views = 0

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
				gif.errors.full_messages.each do |msg|
	    			puts "message #{msg}"
				end
				@saved = false
				@failed_counter = @failed_counter + 1
			end


		end

		puts @saved_counter.to_s + " saved gifs"
		puts @failed_counter.to_s + " failed gifs"

	end

	task :clean_gifs => :environment do
		@gifs = Gif.all

		puts "calculate average_ratio"
		average_ratio = Gif.where('ratio != ?', 0).average('ratio')
		puts "average_ratio " + average_ratio.to_s

		@gifs.each do |gif|
			puts "---------- * ----------"
			puts (gif.id.to_s + ", " + gif.caption)
			if gif.approved == nil
				puts "approved is null"
				gif.approved = false
			end
			if gif.deleted == nil
				puts "deleted is null"
				gif.deleted = false
			end
			if gif.ratio == nil || gif.ratio == 0
				gif.ratio = average_ratio
			end
			if gif.upvotes == nil
				puts "upvotes is null"
				gif.upvotes = 0
			end			
			if gif.downvotes == nil
				puts "downvotes is null"
				gif.downvotes = 0
			end	
			if gif.views == nil
				puts "downvotes is null"
				gif.views = 0
			end	
			gif.save
			puts "gif saved"
			puts ""
		end

	end

	# task :fetch_gifs => :environment do
 #    	gifs = GifutuImport.fetch_gifs()
 #    	@gifs = Gif.delete_all()

 #    	gifs.each do |gif|
 #    		puts gif
 #    		@gif = Gif.new #first_or_create(image_url: gif["image_url"])
 #    		@gif.caption = gif["caption"]
 #    		puts "caption " + @gif.caption

 #    		@gif.url = gif["image_url"]
 #    		puts "url " + @gif.url.to_s
 #    	    if @gif.url != ""
 #    	    	@gif.avatar_remote_url(@gif.url)	
 #    	    end
	#   		@gif.upvotes = gif["upvotes"].to_i + gif["liked"].to_i
	#   		puts "upvotes " + @gif.upvotes.to_s
	#   		@gif.downvotes = gif["downvotes"].to_i + gif["disliked"].to_i
	#   		puts "downvotes " + @gif.downvotes.to_s
	#   		@gif.views = gif["upvotes"].to_i + gif["liked"].to_i + gif["downvotes"].to_i + gif["disliked"].to_i
	#   		puts "views " + @gif.views.to_s

	#   		puts "board name" + gif["board_id"]["name"].to_s
	#   		@gif.tag_list = gif["board_id"]["name"]

	#   		@gif.description = gif["description"].to_s
	#   		puts "description " + @gif.description.to_s

	#   		@gif.approved = false
	# 		@gif.deleted = false


	#   		if @views != 0 || @gif.downvotes == 0

	#   			puts "upvote " + @gif.upvotes.to_i.to_s
	#   			puts "downvote" +  ( @gif.upvotes.to_i + @gif.downvotes.to_i + 1).to_s
	#   			@gif.ratio = @gif.upvotes.to_i / ( @gif.upvotes.to_i + @gif.downvotes.to_i + 1).to_f
	#   			puts "ratio " + @gif.ratio.to_s
	#   			if @gif.save!
	#   				puts @gif.id.to_s + " saved"
	#   			else
	#   				puts "save failed"
	#   			end
	#   		else
	#   			puts "no views - skipping!"
	#   		end

 #    	end
 #    end


end
