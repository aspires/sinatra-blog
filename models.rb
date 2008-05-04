# This file contains the models.

class Entry < Sequel::Model
  set_dataset     DB[:entries]
  set_primary_key :id
end
