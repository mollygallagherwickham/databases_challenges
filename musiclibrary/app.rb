require_relative 'lib/database_connection'
require_relative 'lib/album_repository'

class Application
    def initialize(database_name, io, album_repository)
        DatabaseConnection.connect('music_library')
        @io = io
        album_repository = @album_repository
    end

    def run
        @io.puts 'Welcome to the music library manager!'
        @io.puts 'What would you like to do?'
        @io.puts '1 - List all albums'
        @io.puts '2 - List all artists'
        @io.puts 'Enter your choice:' 
        @io.gets '1'
           
        @io.puts "Here is the list of albums:"
        @io.puts "* 1 - Doolittle"
        @io.puts "* 2 - Surfer Rosa"
        @io.puts "* 3 - Waterloo"
        @io.puts "* 4 - Super Trouper"
        @io.puts "* 5 - Bossanova"
        @io.puts "* 6 - Lover"
        @io.puts "* 7 - Folklore"
        @io.puts "* 8 - I Put a Spell on You"
        @io.puts "* 9 - Baltimore"
        @io.puts "* 10 - Here Comes the Sun"
        @io.puts "* 11 - Fodder on My Wings"
        @io.puts "* 12 - Ring Ring"

    end

end


if __FILE__ == $0
    app = Application.new(
      'music_library',
      Kernel,
      AlbumRepository.new,
    )
    app.run
  end


