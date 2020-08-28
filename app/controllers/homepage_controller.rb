# Controller to manage homepage actions
class HomepageController < ApplicationController
  def index
    if params[:text]
      @results = Sentence.where('LOWER(text) LIKE LOWER(?)', "%#{params[:text]}%").limit(10)
      @results_count = Sentence.where('LOWER(text) LIKE LOWER(?)', "%#{params[:text]}%").count
    else
      @results =[]
      @results_count = 0
    end
  end

  private

  def sentence_params
    params.require(:sentence).permit(:text)
  end
end
