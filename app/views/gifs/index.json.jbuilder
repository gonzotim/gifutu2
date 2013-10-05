json.array!(@gifs) do |gif|
  json.extract! gif, :caption, :upvotes, :downvotes, :views, :ratio
  json.url gif_url(gif, format: :json)
end
