class Album
  attr_accessor(:id, :name, :year, :genre, :artist)

  def initialize (attributes)
    @name = attributes.fetch(:name)   
    @id = attributes.fetch(:id)
    @year = attributes.fetch(:year, 2000).to_i
    @genre = attributes.fetch(:genre, "pop")
    @artist = attributes.fetch(:artist, "kiwi")
    @purchased = false
  end 
  
  def self.all
    #@@albums.values() #hash method -> array
    returned_albums = DB.exec("SELECT * FROM albums;") #array of hashes [{}, {}, ...]
    albums = []
    returned_albums.each() do | album | #album is a hash
      name = album.fetch("name")
      id = album.fetch("id").to_i
      albums.push(Album.new({:name => name, :id => id}))
    end
    albums 
  end

  # def self.sold_all
  #   @@sold_albums.values() #hash method -> array
  # end
  # # Album.all

  # def sold
  #   delete
  #   @@sold_albums[self.id] = self
  # end
  

  def self.update_all_names(new_name) 
    @@albums.each do |album|
    album.name = new_name
    end
  end

  def save
    #@@albums[self.id] = self
    result = DB.exec("INSERT INTO albums (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i #.first returns the first (and only) result of this query.
  end

  # def save
  #   @@albums[self.id] = Album.new(self.name, self.id, self.year, self.genre, self.artist)
  # end
  
  def ==(album_to_compare)
    self.name() == album_to_compare.name()
  end

  def self.clear
    # @@albums = {}
    # @@total_rows = 0
    DB.exec("DELETE FROM albums *;")
  end

  def self.find(id) ##kakunin
    #@@albums[id]
    album = DB.exec("SELECT * FROM albums WHERE id = #{id};").first #.first returns the first (and only) result of this query.
    name = album.fetch("name")
    id = album.fetch("id").to_i
    Album.new({:name => name, :id => id})
  end

  def update(name)
    @name = name
    DB.exec("UPDATE albums SET name = '#{@name}' WHERE id = #{@id};")
  end

  def delete
    #@@albums.delete(self.id) ##kakunin
    DB.exec("DELETE FROM albums WHERE id = #{@id};")
    DB.exec("DELETE FROM songs WHERE album_id = #{@id};")
  end

  def self.search(name)
    self.all.select{| album | album.name.include?(name)}
  end

  def self.sort
    # self.all.sort_by{| album | album.name }
    sorted_albums = DB.exec("SELECT * FROM albums ORDER BY name")
    albums = []
    sorted_albums.each() do | album |
      name = album.fetch("name")
      id = album.fetch("id")
      year = album.fetch("year").to_i
      genre = album.fetch("genre")
      artist = album.fetch("artist")
      albums.push(Album.new({:name => name, :id => id, :year => year, :genre => genre, :artist => artist}))
    end
    albums
  end

  def songs
    Song.find_by_album(self.id)
  end
end