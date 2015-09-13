class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :click]
  before_action :load_question, only: [:show, :edit, :update, :destroy, :click]
  before_action :check_authority, only: [:update, :destroy]
  before_action :build_answer, only: :show
  before_action :gon_current_user, :load_subscription, only: :show
  before_action :load_page, only: :index

  include Voted

  respond_to :js, only: [:create, :update]

  authorize_resource

  caches_page :index

  def index
    respond_with(@questions = Question.all.paginate(page: @page))
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy)
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

    def check_authority
      @question.user = current_user
    end

    def build_answer
      @answer = @question.answers.build
    end

    def gon_current_user
      if user_signed_in?
        gon.current_user = current_user.id
        gon.question_author =  @question.user_id
      end
    end

    def load_subscription
      @subscription = Subscription.where(user: current_user, question: @question).first
    end

    def load_page
      @page = params[:page]
    end
end
