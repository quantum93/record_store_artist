class Artist
  attr_accessor :name
  attr_reader :id

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
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

  def save
    result = DB.exec("INSERT INTO artists (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(artist_to_compare)
    self.name() == artist_to_compare.name()
  end

  def self.clear
    DB.exec("DELETE FROM artists *;")
  end

  def self.find(id)
    artist = DB.exec("SELECT * FROM artists WHERE id = #{id};").first
    if artist
      name = artist.fetch("name")
      id = artist.fetch("id").to_i
      Artist.new({:name => name, :id => id})
    else
      nil
    end
  end

  def update(attributes)
    if (attributes.has_key?(:name)) && (attributes.fetch(:name) != nil)
      @name = attributes.fetch(:name)
      DB.exec("UPDATE artists SET name = '#{@name}' WHERE id = #{@id};")
    end
    album_name = attributes[:album_name]
    album = DB.exec("SELECT * FROM albums WHERE lower(name)='#{album_name.downcase}';").first
    if !album
      Album.new({:name => album_name, :id => nil}).save()
      album = DB.exec("SELECT * FROM albums WHERE lower(name)='#{album_name.downcase}';").first
    end
    DB.exec(%{
      DO $$
      BEGIN
      IF NOT EXISTS
      (SELECT * FROM albums_artists
        WHERE album_id = #{album['id'].to_i} AND artist_id = #{@id})
        THEN
        INSERT INTO albums_artists (album_id, artist_id)
        VALUES (#{album['id'].to_i}, #{@id});
        END IF;
        END $$;
    })
  end

  def delete
    DB.exec("DELETE FROM albums_artists WHERE artist_id = #{@id};")
    DB.exec("DELETE FROM artists WHERE id = #{@id};")
  end

  def albums
    # albums = []
    # results = DB.exec("SELECT album_id FROM albums_artists WHERE artist_id = #{@id};")
    # results.each() do |result|
    #   album_id = result.fetch("album_id").to_i()
    #   album = DB.exec("SELECT * FROM albums WHERE id = #{album_id};")
    #   name = album.first().fetch("name")
    #   albums.push(Album.new({:name => name, :id => album_id}))
    # end
    # albums


    # a way to avoid n+1 query using subquery technique....
    results = DB.exec(%{
      SELECT * FROM albums
      WHERE id IN (
        SELECT album_id FROM albums_artists
        WHERE artist_id = #{@id});
        })
        results.map() do |result|
          id = result.fetch("id").to_i()
          name = result.fetch("name")
          Album.new({:name => name, :id => id})
        end
      end

    end
