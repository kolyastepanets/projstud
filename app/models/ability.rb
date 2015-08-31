class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
    can :click, Question
    can :index, Search
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    alias_action :create, :read, :update, :destroy, :to => :crud
    can :crud, [Question, Answer], user: user
    can :me, User, id: user.id
    can :index, User
    can :create, [:question, :answer]

    can :create, Comment

    can :create, Subscription

    can :click, Question
    can :destroy, Attachment do |attachment|
      attachment.attachable.user_id == user.id
    end
    can :mark_solution, Answer, Answer do |answer|
      answer.question.user == user
    end
    can :vote_up, [Question, Answer] do |votable|
      votable.user_id != user.id && !votable.vote_exists?(user)
    end
    can :vote_down, [Question, Answer] do |votable|
      votable.user_id != user.id && !votable.vote_exists?(user)
    end
    can :cancel_vote, [Question, Answer] do |votable|
      votable.vote_exists?(user)
    end
  end
end
