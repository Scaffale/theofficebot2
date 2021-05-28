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

  describe '#purge_query' do
    subject { purge_query(query) }

    context 'when values with .' do
      let(:query) { 'complex query -a -20.5 and so' }
      it { is_expected.to eq [%w[and complex query so], { delta_before: 0, delta_after: -20.5 }] }
    end

    context 'when double params' do
      let(:query) { 'think so -b 1 -a 2' }
      it { is_expected.to eq [%w[so think], { delta_before: 1.0, delta_after: 2.0 }] }
    end

    context 'special chararacters' do
      let(:query) { "micheal's     bàchelor \"trauma!? -b 1.2 -a 2.4" }
      it { is_expected.to eq [%w[b chelor micheal s trauma], { delta_before: 1.2, delta_after: 2.4 }] }
    end
  end
end
