require 'rubygems'
require 'sinatra'

get '/' do
  haml "== The time is #{Time.now}"
end
