require 'rubygems'
require 'sinatra'
require 'sequel'
require 'json'

# Connect to the database
DB = Sequel.sqlite('blog.db')

# Home page
get '/' do
  haml :home
end

# Get all the entries in JSON format
get '/index.json' do
  entries = DB[:entries].all
  entries.to_json()
end

# View an entry
get '/entry/:slug' do
  entry = DB[:entries][:slug => params[:slug]]
  if entry
    haml :entry
  else
    status 404
    #haml :notfound -- TODO: Create a not found page.
    body "Entry not found."
  end
end

# Get an entry in JSON format
get '/entry/:slug.json' do
  entry = DB[:entries][:slug => params[:slug]]
  if entry
    body entry.to_json()
  else
    status 404
    body nil.to_json()
  end
end
