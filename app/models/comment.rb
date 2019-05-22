class Comment < ApplicationRecord
  belongs_to :resource, polymorphic: true
  belongs_to :user
  validates_presence_of :body
end
