class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:update, :destroy, :mark_solution]
  before_action :set_answer, only: [:update, :mark_solution]
  after_action :publish_answer, only: :create

  include Voted 

  respond_to :js, only: [:update, :destroy, :mark_solution]
  respond_to :json, only: [:create]

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))

    if @answer.save
      render json: { answer: @answer, rating: @answer.rating, attachments: @answer.attachments }
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @answer.update(answer_params)
    @answer.user = current_user
    respond_with(@answer)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def mark_solution
    respond_with(@answer.mark_solution)
  end

  private

    def load_question
      @question = Question.find(params[:question_id])
    end

    def load_answer
      @answer = Answer.find(params[:id])
    end

    def set_answer
      @question = @answer.question
    end

    def publish_answer
      PrivatePub.publish_to "/questions/#{@question.id}/answers", 
        response: { answer: @answer, rating: @answer.rating, 
                    attachments: @answer.attachments }.to_json if @answer.valid?
    end
      
    def answer_params
      params.require(:answer).permit(:body, :question_id, attachments_attributes: [:file, :id, :_destroy])
    end
end
