module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    votes.create(user: user, score: 1)
  end

  def vote_down(user)
    votes.create(user: user, score: -1)
  end

  def cancel_vote(user)
    vote = vote_exists?(user)
    vote.destroy if vote.persisted?
  end

  def rating
    votes.sum(:score)
  end

  def vote_exists?(user)
    votes.find_by(user: user)
  end
end