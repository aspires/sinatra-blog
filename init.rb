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

configure do
  root = File.expand_path(File.dirname(__FILE__))
  set_option :views, File.join(root, 'app', 'views')

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
end

helpers do

  # Use this helper to make not found page a bit easier to display. It abstracts
  # away some of the common code for all "Not found" responses, for example
  # setting the status code to 404.
  #
  # If a block is given, this executes the block (yielding <tt>self</tt>, a
  # Sinatra::EventContext). Else, if the <tt>content</tt> parameter is not nil,
  # this renders <tt>content</tt> (using #body). Otherwise, it renders
  # <tt>notfound.haml</tt>.
  def not_found(content = nil)
    status 404
    if block_given?
      yield self
    elsif content
      body content
    else
      haml :notfound
    end
  end

end

# Set the not found page.
not_found do
  status 404
  haml :notfound
end

# Create the models.
Dir["app/models/*.rb"].each { |x| require x }
# Load the controllers.
Dir["app/controllers/*.rb"].each { |x| load x }
