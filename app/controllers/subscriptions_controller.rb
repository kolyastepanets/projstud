class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_subscription, only: :destroy

  respond_to :js

  authorize_resource

  def create
    respond_with(@subscription = current_user.subscriptions.create(question: @question))
  end

  def destroy
    respond_with(@subscription.destroy)
  end

  private

    def load_question
      @question = Question.find(params[:question_id])
    end

    def load_subscription
      @subscription = Subscription.find(params[:id])
    end
end