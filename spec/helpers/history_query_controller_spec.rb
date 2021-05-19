require 'rails_helper'

RSpec.describe HistoryQueryHelper, type: :helper do
  context 'QueryHistory' do
    let(:query) { 'esempio di ricerca -a 2' }
    subject { helper.find_history_query(query) }
    context 'Creation' do
      context 'when existing' do
        before do
          create(:query_history, text: 'di esempio ricerca', time_after: 2, time_before: nil)
        end

        it 'should not create history' do
          expect { subject }.to change { QueryHistory.count }.by 0
        end

        it 'should increment hits' do
          expect { subject }.to change { QueryHistory.all.last.hits }.by 1
        end
      end

      context 'when not existing' do
        it 'should create one history' do
          expect { subject }.to change { QueryHistory.count }.by 1
        end
      end
    end
  end
end
