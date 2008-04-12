# This file contains all pages we can display.

## General pages.

# The home page, as HTML.
get '/' do
  haml :home
end

## The entries.
# GET    /entries        => Get a list of all entries.
# GET    /entries/new    => Get information on how to create a new entry.
# POST   /entries/create => Create a new entry.
# GET    /entries/slug   => Retrieve an entry.
# PUT    /entries/slug   => Update an entry.
# DELETE /entries/slug   => Delete an entry.

# Get a list of all entries, as JSON.
get '/entries.json' do
  entries = DB[:entries].all
  entries.to_json()
end

# Get a form to create a new entry, as HTML.
get '/entries/new' do
  haml :new
end

# Create a new entry.
post '/entries/create' do
  # Default attributes.
  attributes = {:title => "No title set",
                :slug => "entry-" + Time.now.to_i.to_s,
                :description => "",
                :contents => "",
                :state => "D",
                :date_published => Time.now,
                :user_id => 1,
                :type_id => 1}
  # Overwrite the defaults with the parameters given in the request. HTTP
  # parameters that aren't defined in the above hash will be ignored.
  attributes.each { |key, value| attributes[key] = params[key] || value }
  DB[:entries].insert(attributes)
  body "/entries/#{attributes[:slug]}"
end

# Retrieve an entry, as HTML.
get '/entries/:slug' do
  @entry = DB[:entries][:slug => params[:slug]]
  if @entry
    haml :entry
  else
    status 404
    #haml :notfound -- TODO: Create a not found page.
    body "Entry not found."
  end
end

# Retrieve an entry, as JSON.
get '/entries/:slug.json' do
  entry = DB[:entries][:slug => params[:slug]]
  if entry
    body entry.to_json()
  else
    status 404
    body nil.to_json()
  end
end
