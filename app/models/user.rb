class User < ApplicationRecord
  include PublicActivity::Model

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates_presence_of :name
  validates :password, password_strength: true

  has_many :contact_comments, through: :contacts

  def master?
    if self.role == "master"
      true
    end
  end

  def admin?
    if self.role == "admin"
      true
    end
  end

end
