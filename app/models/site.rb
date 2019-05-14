class Site < ApplicationRecord
  has_many :students
  acts_as_taggable_on :regions, :tags
end
