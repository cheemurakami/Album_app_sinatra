require("sinatra")
require('sinatra/reloader')
require('./lib/album')
require('pry')
require('./lib/song')
require('pg')

DB = PG.connect({:dbname => "record_store"})

also_reload('lib/**/*.rb')

get('/test') do
  @something = "this is a variable"
  erb(:whatever)
end

get('/') do
  @albums = Album.all 
  erb(:albums)
end

get('/albums') do
  if params[:sorted]
    @albums = Album.sort
  else
    @albums = Album.all
  end
  erb(:albums)
end

get('/albums/new') do
  erb(:new_album)
end

patch('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.update(params[:name])
  @albums = Album.all
  erb(:album)
end

get('/albums/wishlist') do

end

post('/albums') do
  name = params[:album_name] #new_album.erb no input name
  year = params[:album_year]
  genre = params[:album_genre]
  artist = params[:album_artist]
  album = Album.new({:name => name, :id => nil, :year => year, :genre => genre, :artist => artist})
  album.save()
  @albums = Album.all()
  erb(:albums)
end

post('/albums/results') do
 searched_words = params[:search]
 @searched_albums = Album.search(searched_words)
 erb(:result)
end

get('/albums/:id/edit') do
  @album = Album.find(params[:id].to_i())
  erb(:edit_album)
end

get('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

patch('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.update(params[:name])
  @albums = Album.all
  erb(:albums)
end

delete('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.delete()
  @albums = Album.all
  erb(:albums)
end


patch('/albums/:id/buy') do
  @album = Album.find(params[:id].to_i())
  @album.sold
  @sold_albums = Album.sold_all
  erb(:purchased)
end

get('/custom_route') do
  "We can even create custom routes, but we should only do this when needed."
end



# Get the detail for a specific song such as lyrics and songwriters.
get('/albums/:id/songs/:song_id') do
  @song = Song.find(params[:song_id].to_i())
  erb(:song)
end

# Post a new song. After the song is added, Sinatra will route to the view for the album the song belongs to.
post('/albums/:id/songs') do
  @album = Album.find(params[:id].to_i())
  song = Song.new(params[:song_name], @album.id, nil)
  song.save()
  erb(:album)
end

# Edit a song and then route back to the album view.
patch('/albums/:id/songs/:song_id') do
  @album = Album.find(params[:id].to_i())
  song = Song.find(params[:song_id].to_i())
  song.update(params[:name], @album.id)
  erb(:album)
end

# Delete a song and then route back to the album view.
delete('/albums/:id/songs/:song_id') do
  song = Song.find(params[:song_id].to_i())
  song.delete
  @album = Album.find(params[:id].to_i())
  erb(:album)
end