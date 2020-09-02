# Controller to manage homepage actions
class HomepageController < ApplicationController
  include QueryHelper

  def index
    if params[:text]
      @results, @extra_params = search_sentence(params[:text])
      @results_count = search_sentence_count(params[:text])
    else
      @results = []
      @results_count = 0
    end
  end

  private

  def sentence_params
    params.require(:sentence).permit(:text)
  end
end
