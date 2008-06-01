## The entries.
# - GET    /entries            => Get a list of all entries.
# - GET    /entries/new        => Get information on how to create a new entry.
#   POST   /entries/new        => Create a new entry.
# - GET    /entries/:slug      => Retrieve an entry.
# - GET    /entries/:slug/edit => Get information on how to update an entry.
#   PUT    /entries/:slug      => Update an entry.
# - DELETE /entries/:slug      => Delete an entry.
#
# FIXME: Shouldn't we return "405 Method Not Allowed" when requesting a URI that
# doesn't support the method given. The HTTP specification (HTTP/1.1, RFC 2616,
# page 66, http://www.ietf.org/rfc/rfc2616.txt) says:
#   10.4.6 405 Method Not Allowed
#     The method specified in the Request-Line is not allowed for the
#     resource identified by the Request-URI. The response MUST include an
#     Allow header containing a list of valid methods for the requested
#     resource.
# So, when for example a DELETE request is sent to /entries/new, a PUT request
# to /entries or a POST to /entries/:slug, maybe we should sent back a 405 error
# with an Allow header listing the allowed methods.

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
  # FIXME: We could -- no, should -- return a "201 Created" status code here.
  # See http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.2.2
end

# Retrieve an entry, as HTML.
get '/entries/:slug' do
  @entry = Entry[:slug => params[:slug]]
  not_found if !@entry
  haml :entry
end

# Retrieve an entry, as JSON.
get '/entries/:slug.json' do
  @entry = Entry[:slug => params[:slug]]
  not_found(nil.to_json) if !@entry
  body @entry.to_json
end

# Get a form to update an entry, as HTML.
get '/entries/:slug/edit' do
  @entry = Entry[:slug => params[:slug]]
  not_found if !@entry
  haml :edit
end

# Update an entry.
put '/entries/:slug' do
  @entry = Entry[:slug => params[:slug]]
  not_found("") if !@entry
  [:title, :slug, :description, :contents, :state].each do |key|
    @entry[key] = params[key]
  end
  @entry.save # TODO: Check if everything's ok.
  redirect "/entries/#{@entry[:slug]}"
end
