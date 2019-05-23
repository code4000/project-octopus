class User < ApplicationRecord
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates_presence_of :name

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
