# Intermediate model to maintain a many to many relationship between folders and
# keys.
class KeyedFolder < ActiveRecord::Base
  belongs_to :key
  belongs_to :folder
end
