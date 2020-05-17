class Song
  attr_reader :id
  attr_accessor :name, :album_id

  # @@songs = {}
  # @@total_rows = 0

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @album_id = attributes.fetch(:album_id)
    @id = attributes.fetch(:id) 
  end

  def ==(song_to_compare)
    (self.name() == song_to_compare.name()) && (self.album_id() == song_to_compare.album_id())
  end

  def self.all
    # @@songs.values
    returned_songs = DB.exec("SELECT * FROM songs;")
    songs = []
    returned_songs.each() do | song |
      name = songs.fetch("name")
      id = songs.fetch("album_id").to_i
      songs.push(Song.new({:name => name, :album_id => album_id,:id => id}))
    end
    songs
  end

  def save
    # @@songs[self.id] = Song.new(self.name, self.album_id, self.id)
    result = DB.exex("INSERT INTO songs (name, album_id) VALUES ('#{@name}', #{@album_id}) RETURNING id;")
    @id = result.first().fetcj("id").to_i
  end

  def self.find(id)
    @@songs[id]
  end

  def update(name, album_id)
    # self.name = name
    # self.album_id = album_id
    # @@songs[self.id] = Song.new(self.name, self.album_id, self.id)
    @name = name
    @album_id = album_id
    DB.exec("UPDATE songs SET name = '#{@name}', album_id = #{@album_id} WHERE id = #{@id};")
  end

  def delete
    # @@songs.delete(self.id)
    DB.exec("DELETE FROM songs WHERE id = #{@id};")
  end

  def self.clear
    # @@songs = {}
    DB.exex("DELETE FROM songs *;")
  end


  
  def self.find_by_album(alb_id)
    songs = []
    # @@songs.values.each do |song|
    #   if song.album_id == alb_id
    #     songs.push(song)
    #   end
    returned_songs = DB.exec("SELECT * FROM songs WHERE album_id = #{alb_id};")
    returned_songs.each() do | song |
      name = song.fetch("name")
      id = song.fetch("id").to_i
      songs.push(Song.new({:name => name, :album_id => alb_id, :id => id}))
    end
  end
    songs
  end

  def album
    # Album.find(self.album_id)
    Album.find(@album_id)
  end
end