require 'rails_helper'

RSpec.describe QueryHelper, type: :helper do
  describe '#extract_number' do
    subject { extract_number(query) }

    context 'when correct query' do
      let(:query) { 'complex query -a 1 asdf' }
      it { is_expected.to eq 1 }

      context 'when multiple params' do
        let(:query) { 'complex query -a 10 asdf -a 4 -b 234, asdf' }
        it { is_expected.to eq 10 }
      end
    end

    context 'when wrong query' do
      context 'when no number' do
        let(:query) { 'complex query -a asdf' }
        it { is_expected.to eq 0 }
      end

      context 'when double result' do
        context 'when 2 numbers' do
          let(:query) { 'complex query -a 10 asdf -a 4' }
          it { is_expected.to eq 10 }
        end

        context 'when no number' do
          let(:query) { 'complex query -a asdf -a' }
          it { is_expected.to eq 0 }
        end
      end
    end
  end

  describe 'purge query' do
    it 'can purge from after' do
      query = 'complex query -a -20.5 and so'
      result = purge_query(query)
      expectation = [%w[and complex query so].sort, { delta_before: 0, delta_after: -20.5 }]
      expect(result).to eq expectation
    end

    it 'can purge from after medium' do
      query = 'think so -b 1 -a 2'
      result = purge_query(query)
      expectation = [%w[so think], { delta_before: 1.0, delta_after: 2.0 }]
      expect(result).to eq expectation
    end

    # context 'special chararacters' do
    #   context 'when spaces' do
    # end
  end
end
