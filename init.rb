require 'rubygems'
require 'sinatra'

get '/' do
  haml :home
end
