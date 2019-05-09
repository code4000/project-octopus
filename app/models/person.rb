class Person < ApplicationRecord
  enum type: %i[learner graduate]
  enum gender: %i[male female]
  acts_as_taggable_on :tags
end
