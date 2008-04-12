# This file contains all pages we can display.

## General pages.

# The home page, as HTML.
get '/' do
  haml :home
end

## The entries.
# GET    /entries       => Get a list of all entries.
# POST   /entries/new   => Create a new entry.
# GET    /entries/slug  => Retrieve an entry.
# PUT    /entries/slug  => Update an entry.
# DELETE /entries/slug  => Delete an entry.

# Get a list of all entries, as JSON.
get '/entries.json' do
  entries = DB[:entries].all
  entries.to_json()
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
