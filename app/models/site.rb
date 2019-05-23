class Site < ApplicationRecord
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  has_many :students
  has_many :comments, as: :resource
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
