module GeocodeHelper

  DAUM_APIKEY = YAML.load_file(Rails.root.join('config','apikey.yml'))['daum']

  def geocode(address)
    url = "http://apis.daum.net/local/geo/addr2coord?apikey=#{DAUM_APIKEY}&output=json&q=#{address}"
    items = JSON.parse(open(URI.encode(url)).read)['channel']['item']
    unless items.blank?
      item = items.first
      [item['lng'], item['lat']]
    end
  end

end