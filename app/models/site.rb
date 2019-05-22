class Site < ApplicationRecord
  has_many :students
  acts_as_taggable_on :regions, :tags
  validates_presence_of :name
  validates_uniqueness_of :name

  def hub?
    if self.tag_list.include?("Hub")
      true
    else
      false
    end
  end
end
