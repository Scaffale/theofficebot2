# Main class, manages inline queries
class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include QueryHelper
  include SentencesHelper
  include BotExplanationHelper

  RESULTS_FOR_QUERY = 3
  RESULTS_FOR_BLANK_QUERY = 10

  def inline_query(query, offset)
    offset = offset.to_i
    # answer_inline_query results, { next_offset: offset + offset_increment }
    results, next_offset = build_results_from_query(query, offset)
    answer_inline_query results, { next_offset: next_offset }
  end

  def chosen_inline_result(result_id, query)
    choosen_result = ChoosenResult.find_by(uniq_id: result_id)
    if choosen_result.nil?
      ChoosenResult.create!(uniq_id: result_id, text: sanitize(query), hits: 1)
    else
      choosen_result.increment!(:hits)
    end
  end

  def start!(_word = nil, *_other_words)
    response = from ? "Ciao #{from['username']}!" : 'Eilà!'
    respond_with :message, text: response

    respond_with :message, text: explanation

    respond_with :message, text: list_of_filters
  end

  private

  def build_results(results_query, extra_params)
    results_query.map do |result|
      {
        type: 'mpeg4_gif',
        id: uniq_id(result.new_name(extra_params)),
        mpeg4_url: [ENV['SERVER_URL'], 'gifs', result.new_name(extra_params)].join('/'),
        thumb_url: [ENV['SERVER_URL'], 'placeholder.jpg'].join('/')
      }
    end
  end

  def build_results_from_query(query, offset)
    if query.blank?
      results = build_results(build_query_choosen_results(limit: RESULTS_FOR_BLANK_QUERY, offset: offset), {})
      [results, (offset + RESULTS_FOR_BLANK_QUERY)]
    else
      results_query, extra_params = search_sentence(query, offset)
      results_query.map { |r| r.build_gif(extra_params) if r.instance_of?(Sentence) }
      results = build_results(results_query, extra_params)
      [results, (offset + RESULTS_FOR_QUERY)]
    end
  end
end
