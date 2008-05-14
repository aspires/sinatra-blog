## General pages.

# The home page, as HTML.
get '/' do
  haml :home
end

# The stylesheet, as CSS.
get '/style.css' do
  sass :style
end
