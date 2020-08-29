# Main class, manages inline queries
class TelegramWebhooksController < Telegram::Bot::UpdatesController
  def inline_query(query, offset)
    Rails.logger.info 'INIZIO IL METODO'
    Rails.logger.info query
    Rails.logger.info offset
    results_query = Sentence.where('LOWER(text) LIKE LOWER(?)', "%#{query}%").limit(10)
    results_query.map(&:build_gif)
    results = results_query.map do |result|
      {
        type: 'mpeg4_gif',
        id: result.new_name,
        mpeg4_url: [ENV['SERVER_URL'], 'gifs', result.new_name].join('/'),
        thumb_url: [ENV['SERVER_URL'], 'placeholder.jpg'].join('/')
      }
    end
    Rails.logger.info results
    answer_inline_query results
  end
end
