class ContactComment < ApplicationRecord
  belongs_to :contact
  belongs_to :user
  validates_presence_of :body

end
