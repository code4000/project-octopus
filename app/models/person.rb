class Person < ApplicationRecord
  enum type: %i[learner graduate]
  enum gender: %i[male female]
end
