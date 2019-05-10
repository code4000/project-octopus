class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

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
