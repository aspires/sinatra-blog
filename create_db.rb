require 'rubygems'
require 'sequel'

# Connect to the database
DB = Sequel.sqlite('blog.db')

# Create the database:
#   CREATE TABLE entries (id integer PRIMARY KEY AUTOINCREMENT, title text,
#   slug text, description blob, contents blob, state varchar(1),
#   date_published timestamp, user_id integer, type_id integer);
DB.create_table :entries do
  primary_key :id,             :integer
  column      :title,          :text
  column      :slug,           :text
  column      :description,    :blob
  column      :contents,       :blob
  column      :state,          :varchar,      :size => 1
  column      :date_published, :timestamp
  column      :user_id,        :integer
  column      :type_id,        :integer
end

# And fill it with some data:
DB[:entries] << {:title => "Hello World!",
                 :slug =>  "hello-world",
                 :description => "Welcome on your new blog. This is the first post.",
                 :contents => "Welcome on your new blog. This is the first post.",
                 :state => "P",
                 :date_published => Time.now,
                 :user_id => 1,
                 :type_id => 1}
