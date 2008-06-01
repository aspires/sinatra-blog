class Entry < Sequel::Model
  set_dataset     DB[:entries]
  set_schema do
    primary_key :id,             :integer
    column      :title,          :text
    column      :slug,           :text
    column      :description,    :blob
    column      :contents,       :blob
    column      :state,          :varchar,      :size => 1
    column      :date_published, :timestamp
    column      :user_id,        :integer
    column      :type_id,        :integer
    # TODO: Should become   foreign_key :user_id, :table => :users
    #       and             foreign_key :type_id, :table => :types
  end

  # Use the default value for any column that is still nil or empty when we're
  # creating a new entry.
  after_initialize do
    if @new
      {:title => "No title set",
       :slug => "entry-" + Time.now.to_i.to_s,
       :description => "",
       :contents => "",
       :state => "D",
       :date_published => Time.now,
       :user_id => 1,
       :type_id => 1
      }.each do |key, value|
        @values[key] = value if @values[key].nil? or @values[key].empty?
      end
    end
  end

  # Returns the permalink to this entry.
  def permalink
    "/entries/#{slug}"
  end

  # Returns the date an entry was published according to the ISO 8601 standard,
  # in the form [YYYY]-[MM]-[DD]T[hh]:[mm]Z
  def date_published_iso8601
    date_published.strftime("%Y-%m-%dT%H:%M:%SZ")
  end

  # Returns the date an entry was published in a human-readable format, in the
  # form "on [full month name] [day of the month], [year] at [hour, 24-hour
  # clock]:[minutes]".
  def date_published_human
    date_published.strftime("on %B %d, %Y at %H:%M")
  end

  # Returns a string containing a serialized version of this object in JSON
  # format.
  def to_json
    attributes = self.values
    attributes[:date_published] = self.date_published_iso8601
    return attributes.to_json
  end

end
