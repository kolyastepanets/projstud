class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create, :destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
    else
      flash[:notice] = "Body can't be blank"
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy
    redirect_to question_path(params[:question_id]), notice: "Your answer successfully deleted."
  end

  private

    def load_question
      @question = Question.find(params[:question_id])
    end

    def answer_params
      params.require(:answer).permit(:body, :question_id)
    end
end
