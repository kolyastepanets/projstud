class SearchController < ApplicationController
  authorize_resource

  def index
    @results = Search.search(params[:query], params[:type])
  end
end