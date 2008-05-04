# This file contains the models.

class Entry < Sequel::Model
  set_dataset     DB[:entries]
  set_primary_key :id

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

end
