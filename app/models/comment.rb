class Comment < ApplicationRecord
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  belongs_to :resource, polymorphic: true
  belongs_to :user
  validates_presence_of :body
end
