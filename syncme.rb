require 'sinatra'
require 'slim'

require_relative 'functions.rb'

enable :sessions
$APP_ID = "404110249640722"
$REDIRECT_URI = "http://syncwithme.herokuapp.com/"
$SCOPE = "publish_stream,read_friendlists,publish_checkins,publish_actions"

get '/' do 
	#check if the user is authenticated and in session
	if session[:user_token].nil?
		if params[:code].nil?
			state = (0...8).map{65.+(rand(25)).chr}.join
			facebook_uri = "https://www.facebook.com/dialog/oauth?client_id=#{$APP_ID}&redirect_uri=#{$REDIRECT_URI}&scope=#{$SCOPE}&state=#{state}"
			redirect facebook_uri
		else
			@user_token = params[:code]
			session[:access_token] = Facebook.getAccessToken @user_token
			#main page here we list all musics
			loved = LastFM.getLoved
			@tracks_loved = LastFM.proper_data loved
			slim :index
		end
	end
end

get '/track' do
	music_index = params[:track].to_i
	tracks_loved = 	LastFM.proper_data LastFM.getLoved
	@cur_track = tracks_loved[music_index]
	@friends = Facebook.getFriends session[:access_token]
	slim :tracks
end

get '/dedicate/' do
	dedicate = Hash.new 
	dedicate[:friend_name] = params[:name]
	dedicate[:friend_id] = params[:id]
	dedicate[:artist_name] = params[:artist]
	dedicate[:song] = params[:track]
	dedicate[:song_url] = params[:url]
	dedicate[:image] = params[:image]
	Facebook.song dedicate , session[:access_token]
end



