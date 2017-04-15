#!/usr/bin/env ruby
require 'sinatra'
require 'digest'

set :port, 9611
set :bind, '0.0.0.0'
set :server, %w[thin webrick]

BASE_PATH = "/var/www/html/files/"
BASE_URL = "http://ruder-babombpi2.nsupdate.info/files/"

post '/upload' do
  unless params[:file] &&
         (tmpfile = params[:file][:tempfile]) &&
         (name = params[:file][:filename])
    status 500
    return "Nothing here"
  end

  extension = File.extname(name)
  sha1digest = Digest::SHA1.new
  while blk = tmpfile.read(65536)
    sha1digest << blk
  end
  newname = sha1digest.hexdigest()[0..8] + extension
  tmpfile.rewind

  File.open(BASE_PATH + newname, "w") do |f|
    IO.copy_stream(tmpfile, f)
  end

  BASE_URL + newname
end
