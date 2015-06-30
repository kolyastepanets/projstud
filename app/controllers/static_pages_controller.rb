class StaticPagesController < ApplicationController
  def home
    @questions = Question.all.paginate(page: params[:page])
  end

  def help
  end
end
