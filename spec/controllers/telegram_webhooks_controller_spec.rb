require 'rails_helper'

RSpec.describe TelegramWebhooksController, type: :controller do
  context 'HistoryQuery' do
    let(:query) { "esempio di ricerca -a 2" }
    subject { TelegramWebhooksController.find_history_query(query) }
    context 'Creation' do
      xcontext 'when existing' do

      end

      context 'when not existing' do
        it 'should create one history' do
          expect(subject).to increase(HistoryQuery.count).by 1
        end
      end
    end
  end
end
