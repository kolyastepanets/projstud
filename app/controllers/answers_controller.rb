class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:update, :destroy, :mark_solution]

  include Voted 

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    if @answer.save
      PrivatePub.publish_to "/questions/#{@question.id}/answers", response: { answer: @answer, rating: @answer.rating, attachments: @answer.attachments }.to_json
      render json: { answer: @answer, rating: @answer.rating, attachments: @answer.attachments }
    else
      flash.now[:notice] = "Body can't be blank"
    end
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
    @answer.user = current_user
  end

  def destroy
    @answer.destroy
    flash.now[:notice] = "Your answer successfully deleted."
  end

  def mark_solution
    @question = @answer.question
    @answer.mark_solution
  end

  private

    def load_question
      @question = Question.find(params[:question_id])
    end

    def load_answer
      @answer = Answer.find(params[:id])
    end
      
    def answer_params
      params.require(:answer).permit(:body, :question_id, attachments_attributes: [:file, :id, :_destroy])
    end
end
