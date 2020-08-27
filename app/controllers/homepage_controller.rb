# Controller to manage homepage actions
class HomepageController < ApplicationController
  def index
    if params[:query]
      @results = Sentence.where("LOWER(text) LIKE LOWER(?)", "%#{params[:query]}%")
    else
      @results = []
    end
  end
end
