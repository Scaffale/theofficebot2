# Main class, manages inline queries
class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include QueryHelper

  def inline_query(query, offset)
    Rails.logger.info "INIZIO IL METODO, query: #{query}, offset: #{offset}"

    if query.blank?
      results_query = random_results if query.blank?
    else
      results_query, extra_params = search_sentence(query)
    end

    results_query.map(&:build_gif)

    results = build_results(results_query)

    Rails.logger.info results
    answer_inline_query results, { next_offset: 10 }
  end

  private

  def build_results(results_query)
    results_query.map do |result|
      {
        type: 'mpeg4_gif',
        id: result.new_name,
        mpeg4_url: [ENV['SERVER_URL'], 'gifs', result.new_name].join('/'),
        thumb_url: [ENV['SERVER_URL'], 'placeholder.jpg'].join('/')
      }
    end
  end

  def random_results
    Sentence.all.sample(10)
  end

  def before_seconds(query)

  end
end
