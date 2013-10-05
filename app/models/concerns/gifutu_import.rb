class GifutuImport
  include HTTParty
  base_uri 'gifutu.com'

  def self.fetch_gifs()
	response = HTTParty.get('http://gifutu.com/gifs.json')

    return response
  end
end