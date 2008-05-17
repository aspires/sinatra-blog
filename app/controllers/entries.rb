## The entries.
# - GET    /entries            => Get a list of all entries.
# - GET    /entries/new        => Get information on how to create a new entry.
#   POST   /entries/new        => Create a new entry.
# - GET    /entries/:slug      => Retrieve an entry.
# - GET    /entries/:slug/edit => Get information on how to update an entry.
#   PUT    /entries/:slug      => Update an entry.
# - DELETE /entries/:slug      => Delete an entry.

# Get a list of all entries, as JSON.
get '/entries.json' do
  body Entry.all.to_json
end

# Get a form to create a new entry, as HTML.
get '/entries/new' do
  haml :new
end

# Create a new entry.
post '/entries/new' do
  @entry = Entry.create(params)
  body "/entries/#{@entry.slug}"
end

# Retrieve an entry, as HTML.
get '/entries/:slug' do
  @entry = Entry[:slug => params[:slug]]
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
  entry = Entry[:slug => params[:slug]]
  if entry
    body entry.to_json
  else
    status 404
    body nil.to_json
  end
end

# Get a form to update an entry, as HTML.
get '/entries/:slug/edit' do
  @entry = Entry[:slug => params[:slug]]
  if @entry
    haml :edit
  else
    status 404
    #haml :notfound -- TODO: Create a not found page.
    body "Entry not found."
  end
end

# Update an entry.
put '/entries/:slug' do
  @entry = Entry[:slug => params[:slug]]
  if @entry
    [:title, :slug, :description, :contents, :state].each do |key|
      @entry[key] = params[key]
    end
    @entry.save # TODO: Check if everything's ok.
    redirect "/entries/#{@entry[:slug]}"
  else
    status 404
    #haml :notfound -- TODO: Create a not found page.
    body "Entry not found."
  end
end
