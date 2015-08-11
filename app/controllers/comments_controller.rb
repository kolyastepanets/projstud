class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [:create]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      PrivatePub.publish_to "/questions/#{question_id}/comments", comment: @comment.to_json
      render json: @comment
      flash.now[:notice] = 'Your comment successfully created.'
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

    def commentable_name
      params[:commentable]
    end

    def comment_params
      params.require(:comment).permit(:content, :question_id)
    end

    def load_commentable
      @commentable = commentable_name.classify
      .constantize.find(params["#{commentable_name.singularize}_id".to_sym])
    end

    def question_id
      @commentable.has_attribute?(:question_id) ? @commentable.question_id : @commentable.id
    end
end
