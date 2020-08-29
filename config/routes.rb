Rails.application.routes.default_url_options[:host] = ENV['SERVER_URL']

Rails.application.routes.draw do
  root 'homepage#index'
  telegram_webhook TelegramWebhooksController
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
