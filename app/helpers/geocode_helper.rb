module GeocodeHelper

  def geocode(address)
    url = "http://apis.daum.net/local/geo/addr2coord?apikey=d6c46bdc42bfcbadad8458e2699b991423207468&output=json&q=#{address}"
    items = JSON.parse(open(URI.encode(url)).read)['channel']['item']
    unless items.blank?
      item = items.first
      [item['lng'], item['lat']]
    end
  end

end