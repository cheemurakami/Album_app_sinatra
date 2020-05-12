class Album
  attr_accessor(:id, :name, :year, :genre, :artist)

  @@albums = {} #hash
  @@total_rows = 0
  @@sold_albums = {}

  def initialize (name, id, year, genre, artist)
    @name = name   
    @id = id || @@total_rows += 1
    @year = year.to_i
    @genre = genre
    @artist = artist
  end 
  
  def self.all
    @@albums.values() #hash method -> array
  end

  def self.sold_all
    @@sold_albums.values() #hash method -> array
  end
  # Album.all

  def self.all_sold
    @@sold_albums.values() #hash method -> array
  end

  def sold
    delete
    @@sold_albums[self.id] = self
  end
  

  def self.update_all_names(new_name)
    @@albums.each do |album|
    album.name = new_name
    end
  end

  def save
    @@albums[self.id] = self
  end



  # def save
  #   @@albums[self.id] = Album.new(self.name, self.id, self.year, self.genre, self.artist)
  # end
  
  # def ==(album_to_compare)
  #   self.name() == album_to_compare.name()
  # end

  def self.clear
    @@albums = {}
    @@total_rows = 0
  end

  def self.find(id)
    @@albums[id]
  end

  def update(name)
    @name = name
  end
    #album = Album.new("kiwi")
  #album.update_name("bee")

  def delete
    @@albums.delete(self.id)
  end

  def self.search(name)
    self.all.select{| album | album.name.include?(name)}
  end

  def self.sort
    self.all.sort_by{| album | album.name }
  end

end