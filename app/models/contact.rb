class Contact < ApplicationRecord
  require 'csv'
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  has_many :comments, as: :resource
  acts_as_taggable_on :tags
  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email

  def name
    self.first_name + ' ' + self.last_name
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      # TODO: show error message if the next line fails (because attributes in file arent correct)
      Contact.create(row.to_hash)
    end
  end

end
