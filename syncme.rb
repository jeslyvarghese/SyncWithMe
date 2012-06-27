require 'sinatra'
require 'slim'

require_relative 'functions.rb'

get '/' do 
	#main page here we list all musics
	loved = LastFM.getLoved
	@tracks_loved = LastFM.proper_data loved
	slim :index
end

post '/track' do
	music_index = params[:track].to_i
	tracks_loved = 	LastFM.proper_data LastFM.getLoved
	@cur_track = tracks_loved[music_index]
	slim :tracks
end


