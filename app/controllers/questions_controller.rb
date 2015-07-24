class QuestionsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show, :click]
    before_action :load_question, only: [:show, :edit, :update, :destroy, :click]
    
    include Voted

    def index
      @questions = Question.all.paginate(page: params[:page])
    end

    def show
      @answer = @question.answers.build
      @answer.attachments.build
      gon.current_user = user_signed_in? && current_user.id
      gon.question_author = user_signed_in? && @question.user_id
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

      respond_to do |format|
        if @question.save
          format.js
          flash[:notice] = 'Your question successfully created.'
        else
          format.js
          flash.now[:notice] = "Try again"
        end
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

    def click
      @question.increment!(:clicks)
      redirect_to @question
    end

    private

      def load_question
        @question = Question.find(params[:id])
      end

      def question_params
        params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
      end
end
