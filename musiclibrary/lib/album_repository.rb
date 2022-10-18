require_relative 'album'

# Repository class
class AlbumRepository
    
    # Selecting all records
    # No arguments
    def all
        # Executes all SQL query
        sql = 'SELECT title, release_year, artist_id FROM albums;'
        result_set = DatabaseConnection.exec_params(sql, [])
        # Returns an array of Album objects

        albums = []

        result_set.each do |record|
            album = Album.new
            album.title = record['title']
            album.release_year = record['release_year']
            album.artist_id = record['artist_id']

            albums << album
        end

        return albums
    end

    # Gets list of albums by its artist id
    # one argument - artist ID
    def find(artist_id)
        # Executes the SQL query
        sql_params = [artist_id]
        sql = 'SELECT title, release_year, artist_id FROM albums WHERE artist_id = $1;'
        result_set = DatabaseConnection.exec_params(sql, sql_params)

        record = result_set[0]
        
        album = Album.new
        album.title = record['title']
        album.release_year = record['release_year']
        album.artist_id = record['artist_id']

        return album
    end


end