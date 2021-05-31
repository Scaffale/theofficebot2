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
        allow(controller).to receive(:answer_inline_query).with([{ id: '000514364000002267.mp4',
                                                                   mpeg4_url: 'plot-twist.casadacorte.it/gifs/000514364000002267.mp4',
                                                                   thumb_url: 'plot-twist.casadacorte.it/placeholder.jpg',
                                                                   type: 'mpeg4_gif' },
                                                                 { id: '000520426000002738.mp4',
                                                                   mpeg4_url: 'plot-twist.casadacorte.it/gifs/000520426000002738.mp4',
                                                                   thumb_url: 'plot-twist.casadacorte.it/placeholder.jpg',
                                                                   type: 'mpeg4_gif' },
                                                                 { id: '000523175000001788.mp4',
                                                                   mpeg4_url: 'plot-twist.casadacorte.it/gifs/000523175000001788.mp4',
                                                                   thumb_url: 'plot-twist.casadacorte.it/placeholder.jpg',
                                                                   type: 'mpeg4_gif' }], { next_offset: 3 })
        subject
      end

      # context 'choosen result present' do
      #   before do
      #     create(:choosen_result, text: query)
      #   end

      #   it 'should answer with 1 choosen and 2 new' do
      #     allow(controller).to receive(:answer_inline_query).with([{ id: 'MyString',
      #                                                                mpeg4_url: 'plot-twist.casadacorte.it/gifs/MyString',
      #                                                                thumb_url: 'plot-twist.casadacorte.it/placeholder.jpg',
      #                                                                type: 'mpeg4_gif' },
      #                                                              { id: '000514364000002267.mp4',
      #                                                                mpeg4_url: 'plot-twist.casadacorte.it/gifs/000514364000002267.mp4',
      #                                                                thumb_url: 'plot-twist.casadacorte.it/placeholder.jpg',
      #                                                                type: 'mpeg4_gif' },
      #                                                              { id: '000520426000002738.mp4',
      #                                                                mpeg4_url: 'plot-twist.casadacorte.it/gifs/000520426000002738.mp4',
      #                                                                thumb_url: 'plot-twist.casadacorte.it/placeholder.jpg',
      #                                                                type: 'mpeg4_gif' }], { next_offset: 3 })
      #     subject
      #   end
      # end

      context 'query empty' do
        let(:query) { '' }

        context 'when choosen results > 10' do
          before do
            14.times.each do |n|
              create(:choosen_result, uniq_id: "MyString#{n}")
            end
          end

          it 'should retrun 10 random results' do
            srand 0
            allow(controller).to receive(:answer_inline_query).with([{ id: 'MyString0',
                                                                       mpeg4_url: 'plot-twist.casadacorte.it/gifs/MyString0',
                                                                       thumb_url: 'plot-twist.casadacorte.it/placeholder.jpg',
                                                                       type: 'mpeg4_gif' },
                                                                     { id: 'MyString1',
                                                                       mpeg4_url: 'plot-twist.casadacorte.it/gifs/MyString1',
                                                                       thumb_url: 'plot-twist.casadacorte.it/placeholder.jpg',
                                                                       type: 'mpeg4_gif' },
                                                                     { id: 'MyString2',
                                                                       mpeg4_url: 'plot-twist.casadacorte.it/gifs/MyString2',
                                                                       thumb_url: 'plot-twist.casadacorte.it/placeholder.jpg',
                                                                       type: 'mpeg4_gif' },
                                                                     { id: 'MyString3',
                                                                       mpeg4_url: 'plot-twist.casadacorte.it/gifs/MyString3',
                                                                       thumb_url: 'plot-twist.casadacorte.it/placeholder.jpg',
                                                                       type: 'mpeg4_gif' },
                                                                     { id: 'MyString4',
                                                                       mpeg4_url: 'plot-twist.casadacorte.it/gifs/MyString4',
                                                                       thumb_url: 'plot-twist.casadacorte.it/placeholder.jpg',
                                                                       type: 'mpeg4_gif' },
                                                                     { id: 'MyString5',
                                                                       mpeg4_url: 'plot-twist.casadacorte.it/gifs/MyString5',
                                                                       thumb_url: 'plot-twist.casadacorte.it/placeholder.jpg',
                                                                       type: 'mpeg4_gif' },
                                                                     { id: 'MyString6',
                                                                       mpeg4_url: 'plot-twist.casadacorte.it/gifs/MyString6',
                                                                       thumb_url: 'plot-twist.casadacorte.it/placeholder.jpg',
                                                                       type: 'mpeg4_gif' },
                                                                     { id: 'MyString7',
                                                                       mpeg4_url: 'plot-twist.casadacorte.it/gifs/MyString7',
                                                                       thumb_url: 'plot-twist.casadacorte.it/placeholder.jpg',
                                                                       type: 'mpeg4_gif' },
                                                                     { id: 'MyString8',
                                                                       mpeg4_url: 'plot-twist.casadacorte.it/gifs/MyString8',
                                                                       thumb_url: 'plot-twist.casadacorte.it/placeholder.jpg',
                                                                       type: 'mpeg4_gif' },
                                                                     { id: 'MyString9',
                                                                       mpeg4_url: 'plot-twist.casadacorte.it/gifs/MyString9',
                                                                       thumb_url: 'plot-twist.casadacorte.it/placeholder.jpg',
                                                                       type: 'mpeg4_gif' }], { next_offset: 10 })
            subject
          end
        end

        context 'when choosen results 0' do
          it 'should retrun 0 results' do
            allow(controller).to receive(:answer_inline_query).with([], { next_offset: 10 })
            subject
          end
        end
      end
    end
  end

  describe '#chosen_inline_result' do
    subject { controller.chosen_inline_result(result_uniq_id, query) }
    let(:query) { 'che' }
    let(:result_uniq_id) { '123456789' }

    context 'choosen_result' do
      context 'choosen_result not present' do
        it 'should create choosen_result' do
          expect { subject }.to change { ChoosenResult.count }.by 1
        end
      end

      context 'choosen_result present' do
        before do
          create(:choosen_result, uniq_id: result_uniq_id, text: query, hits: 1)
        end
        it 'should increment hits on choosed result' do
          expect { subject }.to change { ChoosenResult.all.last.hits }.by 1
        end
      end
    end
  end

  describe '#start!' do
    subject { controller.start! }

    it 'answer with 3 messages' do
      allow(controller).to receive(:respond_with).with(:message, text: 'Eilà!')
      allow(controller).to receive(:respond_with).with(:message, text:
          "Funziono __inline__, quindi comincia a scrivere @plot_twist_bot e se vuoi cercare qualcosa scrivi pure.\n\n    Puoi usare le opzioni:\n\n    -b NUMERO, taglia il video N secondi indietro\n\n    -a NUMERO, taglia il video N secondi avanti\n\n    -f FILTRO, cerca solo in determinati file\n    ")
      allow(controller).to receive(:respond_with).with(:message, text: "Lista dei filtri:\n\n    []\n    ")
      subject
    end
  end
end
