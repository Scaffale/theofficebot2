# Main class, manages inline queries
class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include QueryHelper

  def inline_query(query, offset)
    Rails.logger.info "INIZIO IL METODO, query: #{query}, offset: #{offset}"

    offset = offset.to_i

    if query.blank?
      results_query = random_results if query.blank?
      extra_params = { delta_before: 0, delta_after: 0 }
    else
      results_query, extra_params = search_sentence(query, offset)
    end

    results_query.map {|r| r.build_gif extra_params }

    results = build_results(results_query, extra_params)

    find_history_query(query)

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

  def find_history_query(query)
    purged_query = purge_query(query)
    search_params = { text: purged_query[0].join(' '), time_after: purge_query[1][:delta_after], time_before: purge_query[1][:delat_before] }
    hq = HistoryQuery.find_by(search_params)
    if hq.nil?
      hq = HistoryQuery.create(search_params.join(hits: 1))
    else
      HistoryQuery.increment_counter(:hits, hq.id)
    end
  end
end
