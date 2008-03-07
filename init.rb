require 'rubygems'
require 'sinatra'
require 'sequel'

# Connect to the database
DB = Sequel.sqlite('blog.db')

get '/' do
  haml :home
end
