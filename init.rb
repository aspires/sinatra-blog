require 'rubygems'
require 'sinatra'
require 'sequel'
require 'json'
require 'yaml'

# Load the configuration file.
if !File.exist?('config.yml')
  puts "There's no configuration file at config.yml!"
  exit!
end
CONFIG = YAML.load_file('config.yml')

# Connect to the database
if !File.exist?('config.yml')
  puts "There's no database file at blog.db! Create an empty file called " +
       "blog.db and run 'ruby create_db.rb' to create the database."
  exit!
end
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
  @entry = DB[:entries][:slug => params[:slug]]
  if @entry
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
