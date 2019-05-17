class Contact < ApplicationRecord
  has_many :contact_comments
  acts_as_taggable_on :tags
  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email

  def name
    self.first_name + ' ' + self.last_name
  end
end
