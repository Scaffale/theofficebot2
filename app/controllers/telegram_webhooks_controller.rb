# Main class, manages inline queries
class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include QueryHelper
  include HistoryQueryHelper
  include SentencesHelper

  def inline_query(query, offset)
    offset = offset.to_i
    if query.blank?
      results_query = random_results if query.blank?
      extra_params = { delta_before: 0, delta_after: 0 }
    else
      results_query, extra_params = search_sentence(query, offset)
    end
    # Parallel.map(results_query, in_threads: 2) { |r| r.build_gif extra_params }
    results_query.map { |r| r.build_gif extra_params }
    results = build_results(results_query, extra_params)
    update_history_query(query)
    answer_inline_query results, { next_offset: offset + 3 }
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

  def random_results
    Sentence.all.sample(3)
  end

  def before_seconds(query); end
end
