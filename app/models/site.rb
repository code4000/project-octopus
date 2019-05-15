class Site < ApplicationRecord
  has_many :students
  acts_as_taggable_on :regions, :tags
  validates_presence_of :name
  validates_uniqueness_of :name
end
