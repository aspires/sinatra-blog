# This file initializes our Sinatra-powered blog.

# Require the necessary libraries.
require 'rubygems'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/vendor/sinatra/lib')
require 'sinatra'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/vendor/sequel/sequel_core/lib',
                   File.dirname(__FILE__) + '/vendor/sequel/sequel/lib')
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

# Create the models.
Dir["app/models/*.rb"].each { |x| require x }
# Load the controllers.
Dir["app/controllers/*.rb"].each { |x| load x }
