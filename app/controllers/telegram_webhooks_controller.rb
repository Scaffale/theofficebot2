# Main class, manages inline queries
class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include QueryHelper
  include HistoryQueryHelper
  include SentencesHelper

  RESULTS_FOR_QUERY = 3
  RESULTS_FOR_BLANK_QUERY = 10

  def inline_query(query, offset)
    offset = offset.to_i
    results, offset_increment = if query.blank?
                                  [build_results_from_choosen_results(random_results), RESULTS_FOR_BLANK_QUERY]
                                else
                                  build_results_from_query(query, offset)
                                end
    answer_inline_query results, { next_offset: offset + offset_increment }
  end

  def chosen_inline_result(result_id, query)
    choosen_result = ChoosenResult.find_by(uniq_id: result_id)
    if choosen_result.nil?
      ChoosenResult.create!(uniq_id: result_id, query_history: find_or_create_query_sanitized(query), hits: 1)
    else
      choosen_result.increment!(:hits)
    end
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

  def build_results_from_choosen_results(choosen_results)
    choosen_results.map do |result|
      {
        type: 'mpeg4_gif',
        id: result.uniq_id,
        mpeg4_url: [ENV['SERVER_URL'], 'gifs', result.uniq_id].join('/'),
        thumb_url: [ENV['SERVER_URL'], 'placeholder.jpg'].join('/')
      }
    end
  end

  def build_results_from_query(query, offset)
    results_query, extra_params = search_sentence(query, offset)
    # Parallel.map(results_query, in_threads: 2) { |r| r.build_gif extra_params }
    results_query.map { |r| r.build_gif extra_params }
    results = build_results(results_query, extra_params)
    update_history_query(query)
    [results, RESULTS_FOR_QUERY]
  end

  def random_results
    ChoosenResult.all.order(hits: :desc).limit(RESULTS_FOR_BLANK_QUERY)
  end

  def before_seconds(query); end
end
