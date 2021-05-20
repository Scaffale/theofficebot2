# Main class, manages inline queries
class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include QueryHelper
  include HistoryQueryHelper

  def inline_query(query, offset)
    Rails.logger.info "INIZIO IL METODO, query: #{query}, offset: #{offset}"

    offset = offset.to_i

    if query.blank?
      results_query = random_results if query.blank?
      extra_params = { delta_before: 0, delta_after: 0 }
    else
      results_query, extra_params = search_sentence(query, offset)
    end

    results_query = Parallel.map(results_query).map { |r| r.build_gif extra_params }

    results = build_results(results_query, extra_params)

    update_history_query(query)

    Rails.logger.info results
    answer_inline_query results, { next_offset: offset + 3 }
  end

  private

  def build_results(results_query, extra_params)
    results_query.map do |result|
      {
        type: 'mpeg4_gif',
        id: result.new_name(extra_params).hash.to_s,
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
