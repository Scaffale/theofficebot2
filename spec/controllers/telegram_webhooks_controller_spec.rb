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
        allow(controller).to receive(:answer_inline_query).with([{ id: '-000514364-000002267-.mp4',
                                                                   mpeg4_url: 'plot-twist.casadacorte.it/gifs/-000514364-000002267-.mp4',
                                                                   thumb_url: 'plot-twist.casadacorte.it/placeholder.jpg',
                                                                   type: 'mpeg4_gif' },
                                                                 { id: '-000520426-000002738-.mp4',
                                                                   mpeg4_url: 'plot-twist.casadacorte.it/gifs/-000520426-000002738-.mp4',
                                                                   thumb_url: 'plot-twist.casadacorte.it/placeholder.jpg',
                                                                   type: 'mpeg4_gif' },
                                                                 { id: '-000523175-000001788-.mp4',
                                                                   mpeg4_url: 'plot-twist.casadacorte.it/gifs/-000523175-000001788-.mp4',
                                                                   thumb_url: 'plot-twist.casadacorte.it/placeholder.jpg',
                                                                   type: 'mpeg4_gif' }], { next_offset: 3 })
        subject
      end
    end
  end
end
