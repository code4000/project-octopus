class Ability
  include CanCan::Ability

  def initialize(user)

      if user.present?
        can :read, :all
        can :search, :all
        can :manage, Site if user.admin?
        can :manage, Student if user.admin?
        can :manage, Contact if user.admin?
        can :manage, Comment, user_id: user.id
        can :manage, :all if user.master?
      end

  end
end
