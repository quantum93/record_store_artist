describe('#update') do
  it("adds an album to an artist") do
    artist = Artist.new({:name => "John Coltrane", :id => nil})
    artist.save()
    album = Album.new({:name => "A Love Supreme", :id => nil})
    album.save()
    artist.update({:album_name => "A Love Supreme"})
    expect(artist.albums).to(eq([album]))
    artist.update({:album_name => "A Love Supreme"})
    result = DB.exec("SELECT * FROM albums_artists WHERE album_id = #{album.id} AND artist_id = #{artist.id}")
    expect(result.values.length).to(eq(1))
  end
end

describe('#update') do
  it("adds an album to an artist") do
    artist = Artist.new({:name => "John Coltrane", :id => nil})
    artist.save()
    artist.update({:album_name => "A Love Supreme"})
    album = artist.albums[0]
    expect(album.name).to(eq("A Love Supreme"))
  end
end
