class Student < ApplicationRecord
  belongs_to :site, optional: true
  acts_as_taggable_on :tags
end
