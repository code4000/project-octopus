class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates_presence_of :name

  has_many :contact_comments, through: :contacts
  has_many :articles

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

  def publisher?
    if self.role == "publisher"
      true
    end
  end

end
