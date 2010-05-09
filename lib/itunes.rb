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
