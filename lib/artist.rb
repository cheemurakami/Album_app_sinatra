class Artist

  def initialize (attributes)
    @name = attributes.fetch(:name)   
    @id = attributes.fetch(:id)
  end 

  #1. Update the artist name
  #2. Create a link between this artist and an album
  def update(attributes)
    if (attributes.has_key?(:name)) && (attributes.fetch(:name) != nil)
      @name = attributes.fetch(:name)
      DB.exec("UPDATE artists SET name = '#{@name}' WHERE id = #{@id};")
    elsif  (attributes.has_key?(:album_name)) && (attributes.fetch(:album_name) != nil)
      album_name = attributes.fetch(:album_name)
      album = DB.exec("SELECT * FROM albums WHERE lower(name)='#{album_name.downcase}';").first
      # {"id" => 2, "name" => ""A Love Supreme"}
      if album != nil
        #Make a new connector row in table
        DB.exec("INSERT INTO albums_artists (album_id, artist_id) VALUES (#{album['id'].to_i}, #{@id});")
      end
    end
  end


  # def should_create_link(attributes)
  #   #checking to see if it looks like {:album_name => "A Love Supreme"}
  #   (attributes.has_key?(:album_name)) && (attributes.fetch(:album_name) != nil)
  # end

  def albums
    albums = []
    results = DB.exec("SELECT album_id FROM albums_artists WHERE artist_id = #{@id};")
    #[
    # {album_id: 2},
    # {album_id: 3},
    # {album_id: 4}
    # ]
    results.each() do |result|
      album_id = result.fetch("album_id").to_i()
      album = DB.exec("SELECT * FROM albums WHERE id = #{album_id};")
      #[{id:2, name: "Kiwi album", year: "2000" ...}]
      name = album.first().fetch("name")
      year = album.first().fetch("year").to_i
      genre = album.first().fetch("genre")
      artist = album.first().fetch("artist")
      albums.push(Album.new({:name => name, :id => album_id, :year => year, :genre => genre, :artist => artist}))
    end
    albums
  end

  def delete
    DB.exec("DELETE FROM albums_artists WHERE artist_id = #{@id};")
    DB.exec("DELETE FROM artists WHERE id = #{@id};")
  end

  def save
    result = DB.exec("INSERT INTO artists (name) VALUES ('#{@name}')RETURNING id;")
    @id = result.first().fetch("id").to_i
  end


  
  def self.all
    returned_artists = DB.exec("SELECT * FROM artists;")
    artists = []
    returned_artists.each() do |artist|
      name = artist.fetch("name")
      id = artist.fetch("id").to_i
      artists.push(Artist.new({:name => name, :id => id}))
    end
    artists
  end
  
  def self.clear
    DB.exec("DELETE FROM artists *;")
  end

  def self.find(id)
    artist = DB.exex("SELECT * FROM artists WHERE id = #{id};").first
    name = artist.fetch("name")
    id = artist.fetch("id").to_i
    Artist.new({:name => name, :id => id})
  end

  def ==(artist_to_compare)
    self.name() == artist_to_compare.name()
  end

  def delete
    DB.exec("DELETE FROM artists WHERE id = #{@id};")
  end


end
