require 'rails_helper'
require 'telegram/bot/updates_controller/rspec_helpers'

RSpec.describe TelegramWebhooksController, type: :telegram_bot_controller do
  fixtures :sentences
  describe '#inline_query' do
    subject { controller.inline_query(query, offset) }

    context 'correct query' do
      let(:offset) { 0 }
      let(:query) { 'che' }

      it 'should answer with 3 results' do
        allow(controller).to receive(:answer_inline_query).with(instance_of(Array), { next_offset: 3 })
        subject
      end
    end
  end
end
