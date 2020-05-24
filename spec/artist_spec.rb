require('spec_helper')

describe  ('#Artist') do
  describe('#update') do
    it("adds an album to an artist") do
      artist = Artist.new({:name => "John Coltrane", :id => nil})
      artist.save()
      album = Album.new({:name => "A Love Supreme", :id => nil, :year => 2020, :genre => "neko", :artist => "kiwi"})
      album.save()
      artist.update({:album_name => "A Love Supreme"})
      # artist.update({:album_name => "An album that isn't here"})
      # artist.update({:name => "Kiwi"})
      # artist.update({:foo => "bleh"})
      expect(artist.albums).to(eq([album]))
    end
  end
end


