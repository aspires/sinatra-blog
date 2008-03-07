require 'rubygems'
require 'sinatra'
require 'sequel'
require 'json'

# Connect to the database
DB = Sequel.sqlite('blog.db')

get '/' do
  haml :home
end

# Get all the entries in JSON format
get '/index.json' do
  entries = DB[:entries].all
  entries.to_json()
end
