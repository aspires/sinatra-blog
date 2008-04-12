# This file initializes our Sinatra-powered blog.

# Require the necessary libraries.
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
if !File.exist?('blog.db')
  puts "There's no database file at blog.db! Create an empty file called " +
       "blog.db and run 'ruby create_db.rb' to create the database."
  exit!
end
DB = Sequel.sqlite('blog.db')

# Load the pages we can display.
load './pages.rb'
