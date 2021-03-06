require 'rspec'
require 'pry'
require 'album'
require 'song'

describe ('#Album') do

  before(:each) do
    Album.clear()
  end

  describe('.all') do
    it ("returns an empty array when there are no albums") do
      expect(Album.all).to eq([])
    end
  end

  it('creates a new album') do
    album = Album.new({:name => "kiwis best hits", :id => nil, :year => 2020, :genre => "neko", :artist => "kiwi"})
    expect(album.year).to eq(2020)
    
  end
  
  describe('#save') do
    it("saves an album") do
      album = Album.new({:name => "kiwis best hits", :id => nil, :year => 2020, :genre => "neko", :artist => "kiwi"}) # nil added as second argument
      album.save()
      album2 = Album.new({:name => "kiwis other best hits", :id => nil, :year => 2021, :genre => "neko", :artist => "kiwi"}) # nil added as second argument
      album2.save()
      expect(Album.all).to(eq([album, album2]))
    end
  end
 
  # describe('#==') do
  #   it("is the same album if it has the same attributes as another album") do
  #     album = Album.new("kiwis best hits", nil, 2020, "neko", "kiwi")
  #     album2 = Album.new("kiwis best hits", nil, 2021, "neko", "kiwi")
  #     expect(album).to(eq(album2))
  #   end
  # end

  describe('.clear') do
    it("clears all albums") do
      album = Album.new({:name => "kiwis best hits", :id => nil, :year => 2020, :genre => "neko", :artist => "kiwi"})
      album.save()
      album2 = Album.new({:name => "kiwis other best hits", :id => nil, :year => 2021, :genre => "neko", :artist => "kiwi"})
      album2.save()
      Album.clear()
      expect(Album.all).to(eq([]))
    end
  end

  describe('.find') do
    it("finds an album by id") do
      album = Album.new({:name => "kiwis best hits", :id => nil, :year => 2020, :genre => "neko", :artist => "kiwi"})
      album.save()
      album2 = Album.new({:name => "kiwis other best hits", :id => nil, :year => 2021, :genre => "neko", :artist => "kiwi"})
      album2.save()
      expect(Album.find(album.id)).to(eq(album))
    end
  end

  describe('#update') do
    it("updates an album by id") do
      album = Album.new({:name => "kiwis best hits", :id => nil, :year => 2020, :genre => "neko", :artist => "kiwi"})
      album.save()
      album.update("A Love Supreme")
      expect(album.name).to(eq("A Love Supreme"))
    end
  end

  describe('#delete') do
    it("deletes an album by id") do
      album = Album.new({:name => "kiwis best hits", :id => nil, :year => 2020, :genre => "neko", :artist => "kiwi"})
      album.save()
      album2 = Album.new({:name => "kiwis best hits", :id => nil, :year => 2020, :genre => "neko", :artist => "kiwi"})
      album2.save()
      album.delete()
      expect(Album.all).to(eq([album2]))
    end
  end

  describe('.search') do
    it("searches an album by name") do
      album = Album.new({:name => "kiwis best hits", :id => nil, :year => 2020, :genre => "neko", :artist => "kiwi"})
      album.save()
      album2 = Album.new({:name => "kiwis best hits", :id => nil, :year => 2020, :genre => "neko", :artist => "kiwi"})
      album2.save()
      album3 = Album.new({:name => "chi's other best hits", :id => nil, :year => 2020, :genre => "human", :artist => "chi"})
      album3.save()
      # expect(Album.search(album.name)).to(eq(album))
      expect(Album.search("kiwi")).to(eq([album, album2]))
    end
  end

  describe('.sort') do
    it("sorts albums in alphabetical order") do
      album = Album.new({:name => "kiwis best hits", :id => nil, :year => 2020, :genre => "neko", :artist => "kiwi"})
      album.save()
      album2 = Album.new({:name => "kiwis new hits", :id => nil, :year => 2020, :genre => "neko", :artist => "kiwi"})
      album2.save()
      album3 = Album.new({:name => "chi's other best hits", :id => nil, :year => 2020, :genre => "human", :artist => "chi"})
      album3.save()
      # expect(Album.search(album.name)).to(eq(album))
      expect(Album.sort).to(eq([album3, album, album2]))
    end
  end

  describe('#sold') do
    it("lists sold albums") do
      album = Album.new({:name => "kiwis best hits", :id => nil, :year => 2020, :genre => "neko", :artist => "kiwi"})
      album.save()
      album2 = Album.new({:name => "kiwis new hits", :id => nil, :year => 2010, :genre => "neko", :artist => "kiwi"})
      album2.save()
      album3 = Album.new({:name => "chi's other best hits", :id => nil, :year => 2020, :genre => "human", :artist => "chi"})
      album3.save()
      album.sold #also moves into @@sold_albums
      expect(Album.sold_all).to(eq([album]))
      expect(Album.all).to(eq([album2, album3]))
    end
  end
  describe('#songs') do
    it("returns an album's songs") do
      album = Album.new({:name => "Giant Steps", :id => nil, :year => 2000, :genre => "pop", :artist => "chee"})
      album.save()
      song = Song.new("Naima", album.id, nil)
      song.save()
      song2 = Song.new("Cousin Mary", album.id, nil)
      song2.save()
      expect(album.songs).to(eq([song, song2]))
    end
  end
end