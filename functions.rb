#serves all the functionalities for syncme.
require 'curl'
require 'xmlsimple'
require 'fb_graph'


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

class Facebook
	$APP_ID ="404110249640722"
	$REDIRECT_URI = "http://syncwithme.herokuapp.com/"
	$SECRET = "66ed6b8491b9e3ec4ae7545742038924"
	def self.getFriends(access_token)
		me = FbGraph::User.me access_token
		friends = me.friend_lists
		friends_clean = friends.map do |friend|
			friend_detail = Hash.new 
			friend_detail[:id] = friend.id
			friend_detail[:name] = friend.name
			friend_detail[:profile_pic] =  "http://graph.facebook.com/#{friend.id}/picture"
			friend_detail
		end
	end

	def self.getAccessToken(code)
		url = "https://graph.facebook.com/oauth/access_token?
    		   	client_id=#{$APP_ID}
   			   	&redirect_uri=#{$REDIRECT_URI}
   			   	&client_secret=#{$SECRET}
   			 	&code=#{code}"
		url_return = Curl::Easy.http_get url
		url_return = url_return.split('&')
		access_token=url_return[0].to_s
		access_token.delete "access_token"
	end
end