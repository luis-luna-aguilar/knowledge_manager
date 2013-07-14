class SearchesController < ApplicationController

  def index
  end

  def new
  	@search = Search.new
  end

end
