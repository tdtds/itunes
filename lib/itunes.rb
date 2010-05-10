#!/usr/bin/env ruby
#coding:utf-8

require 'win32ole'

module ITunes
	class App
		def initialize
			@itunes = WIN32OLE::new( 'iTunes.Application' )
		end

		def playlists
			pls = @itunes.LibrarySource.Playlists
			pls.extend Playlists
			pls
		end
	end

	module Playlists
		def size
			count
		end
	end
end

if __FILE__ == $0 then
	begin
		itunes = ITunes::App::new
		pls = itunes.playlists
		pls.each do |list|
			print "#{list.name}: #{list.kind} - "
			begin
				puts list.SpecialKind
			rescue WIN32OLERuntimeError
				puts 'no special kind'
			end
		end
	rescue WIN32OLERuntimeError
		$stderr.puts $!
		exit
	end
end
