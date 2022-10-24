require 'album_repository'
require 'album'

RSpec.describe AlbumRepository do
  def reset_albums_table
    seed_sql = File.read('spec/seeds_albums.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end
  
  before(:each) do 
    reset_albums_table
  end
    
      # (your tests will go here).
  it "returns all albums" do
    repo = AlbumRepository.new

    albums = repo.all
    expect(albums.length).to eq 12
    expect(albums[2].title).to eq 'Waterloo'
    expect(albums[2].release_year).to eq '1974'
  end

  it "returns 1 album based on artist ID" do
    repo = AlbumRepository.new

    album = repo.find(5)
    expect(album.title).to eq 'Hopes and Fears'
    expect(album.release_year).to eq '2004'
    expect(album.artist_id).to eq '5'
  end

  it "creates new album" do
    repository = AlbumRepository.new

    new_album = Album.new
    new_album.title = 'Trompe le Monde'
    new_album.release_year = 1991
    new_album.artist_id = 1

    repository.create(new_album)

    all_albums = repository.all

    expect(all_albums).to include (
      have_attributes(
        title: new_album.title, 
        release_year: '1991'
      )  
    )
  end

  it "deletes album from table" do
    repo = AlbumRepository.new

    album = repo.delete(5)
    all_albums = repo.all
    expect(all_albums).not_to include (
      have_attributes(
        id: 5 
      )  
    )
  end
end