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

  describe '#chosen_inline_result' do
    subject { controller.chosen_inline_result(result_uniq_id, query) }
    let(:query) { 'che' }
    let(:result_uniq_id) { '123456789' }

    context 'when query_history present' do
      before do
        create(:query_history, text: query, time_before: 0, time_after: 0)
      end

      context 'choosen_result' do
        context 'choosen_result not present' do
          it 'should create choosen_result' do
            expect { subject }.to change { ChoosenResult.count }.by 1
          end
        end

        context 'choosen_result present' do
          before do
            qh = create(:query_history, text: query)
            create(:choosen_result, uniq_id: result_uniq_id, query_history: qh, hits: 1)
          end
          it 'should increment hits on choosed result' do
            expect { subject }.to change { ChoosenResult.all.last.hits }.by 1
          end
        end
      end
    end

    context 'when query_history not present' do
      context 'choosen_result' do
        context 'choosen_result not present' do
          it 'should create choosen_result' do
            expect { subject }.to change { ChoosenResult.count }.by 1
          end
        end

        context 'choosen_result present' do
          before do
            qh = create(:query_history, text: query)
            create(:choosen_result, uniq_id: result_uniq_id, query_history: qh, hits: 1)
          end
          it 'should increment hits on choosed result' do
            expect { subject }.to change { ChoosenResult.all.last.hits }.by 1
          end
        end
      end
    end
  end
end
