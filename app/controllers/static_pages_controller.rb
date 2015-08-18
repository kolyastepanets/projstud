class StaticPagesController < ApplicationController
  skip_authorization_check

  def home
    @questions = Question.all.paginate(page: params[:page])
  end

  def help
  end
end
