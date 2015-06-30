class QuestionsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :load_question, only: [:show, :edit, :update, :destroy]

    def index
      @questions = Question.all.paginate(page: params[:page])
    end

    def show
      @answer = @question.answers.build
      @answer.attachments.build
    end

    def new
      @question = Question.new
      @question.attachments.build
    end

    def edit
    end

    def create
      @question = Question.new(question_params)
      @question.user = current_user

      if @question.save
        redirect_to @question
        flash[:notice] = 'Your question successfully created.'
      else
        render :new
      end
    end

    def update
      @question.update(question_params)
      @question.user = current_user
    end

    def destroy
      @question.destroy
      redirect_to questions_path
      flash[:notice] = "Your question successfully deleted."
    end
    private

      def load_question
        @question = Question.find(params[:id])
      end

      def question_params
        params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
      end
end
