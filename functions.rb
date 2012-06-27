#serves all the functionalities for syncme.
require 'curl'
require 'xmlsimple'
class LastFM
	
	$API_KEY = "bd3651487fe2899b128df40502008df8"

	def self.url(method)
		case method
			when 'loved tracks'
				return "http://ws.audioscrobbler.com/2.0/?method=chart.getlovedtracks&api_key=#{$API_KEY}"
		end
	end

	def self.getLoved
		
		curl_handle = Curl::Easy.http_get url 'loved tracks'
		response_body =  curl_handle.body_str
		simplified_xml = XmlSimple.xml_in response_body
		simplified_xml["tracks"][0]["track"] if simplified_xml["status"] == "ok"		 
	end	

	def self.proper_data(loved)
		unless loved.nil?
			tracks_loved = Array.new
			loved.each do |track|
				new_track = Hash.new
				new_track[:name] = track['name'][0]
				new_track[:artist] = track['artist'][0]['name'][0]
				new_track[:icon] = track['image'][2]["content"] unless track['image'].nil?
				new_track[:image] = track['image'][3]["content"] unless track['image'].nil?
				new_track[:url] = track['url'][0]
				tracks_loved<<new_track
			end
			tracks_loved
		end
	end
end