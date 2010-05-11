#!/usr/bin/env ruby
#coding:utf-8

require 'win32ole'

module ITunes
	class App
		def initialize
			@itunes = WIN32OLE::new( 'iTunes.Application' )
		end

		def each_playlist
			playlists.each do |list|
				yield list.extend( Playlist )
			end
		end

		def playlist( name )
			playlists.ItemByName( name ).extend( Playlist )
		end

		def playlists
			pls = @itunes.LibrarySource.Playlists
			pls.extend Playlists
			pls
		end
	end

	module Playlists
	end

	module Playlist
		def kind
			k = self.Kind
			return k if k == 1

			special_kind
		end

		def special_kind
			begin
				self.SpecialKind
			rescue WIN32OLERuntimeError
				nil
			end
		end

		KINDS = {
			0 => :PLAYLIST,
			1 => :LIBRARY,
			2 => :DJ,
			3 => :PODCAST,
			6 => :MUSIC,
			7 => :MOVIE,
			8 => :TV,
			11 => :GENIUS,
		}
		def to_symbol( kind_code )
			KINDS[kind_code]
		end

		def count
			self.Tracks.Count
		end
	end
end

if __FILE__ == $0 then
	begin
		itunes = ITunes::App::new
		first = nil
		itunes.each_playlist do |list|
			puts "#{list.name}: #{list.to_symbol( list.kind )}"
			first = list.name if list.kind == 0 and !first
		end

		puts
		puts "Detail of #{first} list"
		list = itunes.playlist( first )
		puts "\tCount: #{list.count}"
	rescue WIN32OLERuntimeError
		$stderr.puts $!
		exit
	end
end
