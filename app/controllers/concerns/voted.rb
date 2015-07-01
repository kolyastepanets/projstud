module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down, :cancel_vote]
  end

  def vote_up
    if current_user.id != @votable.user_id
      unless @votable.vote_exists?(current_user)
        @votable.vote_up(current_user)
        render json: { votable_id: @votable.id, rating: @votable.rating, type: @votable.class.name }
      end
    end
  end

  def vote_down
    if current_user.id != @votable.user_id
      unless @votable.vote_exists?(current_user)
        @votable.vote_down(current_user)
        render json: { votable_id: @votable.id, rating: @votable.rating, type: @votable.class.name }
      end
    end
  end

  def cancel_vote
    if @votable.vote_exists?(current_user)
      @votable.cancel_vote(current_user)
      render json: { votable_id: @votable.id, rating: @votable.rating, type: @votable.class.name }
    end
  end

  private

    def model_klass
      controller_name.classify.constantize
    end
      
    def set_votable
      @votable = model_klass.find(params[:id])
    end
end