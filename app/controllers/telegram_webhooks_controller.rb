# Main class, manages inline queries
class TelegramWebhooksController < Telegram::Bot::UpdatesController
  def inline_query(query, offset)
    p query
    p offset
    results_query = Sentence.where('LOWER(text) LIKE LOWER(?)', "%#{query}%").limit(10)
    results = results_query.map do |result|
      {
        type: 'mpeg4_gif',
        id: result.new_name,
        mpeg4_url: [ENV['SERVER_URL'], result.build_gif].join('/'),
        thumb_url: [ENV['SERVER_URL'], 'placeholder.jpg'].join('/')
      }
    end
    answer_inline_query results
  end
end
