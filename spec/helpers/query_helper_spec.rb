require 'rails_helper'

RSpec.describe QueryHelper, type: :helper do
  describe '#extract_option' do
    subject { extract_option(query, letter) }
    let(:letter) { 'a' }

    context 'when correct query' do
      let(:query) { 'complex query -a 1 asdf' }
      it { is_expected.to eq ['complex query asdf', 1] }

      context 'when multiple params' do
        let(:query) { 'complex query -a 10 asdf -a 4 -b 234, asdf' }
        it { is_expected.to eq ['complex query asdf -a 4 -b 234, asdf', 10] }
      end
    end

    context 'when wrong query' do
      context 'when no number' do
        let(:query) { 'complex query -a asdf' }
        it { is_expected.to eq ['complex query -a asdf', 0] }
      end

      context 'when double result' do
        context 'when 2 numbers' do
          let(:query) { 'complex query -a 10 asdf -a 4' }
          it { is_expected.to eq ['complex query asdf -a 4', 10] }
        end

        context 'when no number' do
          let(:query) { 'complex query -a asdf -a' }
          it { is_expected.to eq ['complex query -a asdf -a', 0] }
        end
      end
    end
  end

  describe '#extratct_filter' do
    subject { extract_filter(query, filter) }
    let(:filter) { 'f' }

    context 'when correct filter' do
      let(:query) { 'complex query -f asd' }

      it { is_expected.to eq ['complex query', 'asd'] }

      context 'when mixed query' do
        let(:query) { 'complex query -f asd and so' }
        it { is_expected.to eq ['complex query  and so', 'asd'] }
      end
    end
  end

  describe '#purge_query' do
    subject { purge_query(query) }

    context 'when values with .' do
      let(:query) { 'complex query -a -20.5 and so' }
      it { is_expected.to eq [%w[and complex query so], { delta_before: 0, delta_after: -20.5, file_filter: nil }] }
    end

    context 'when double params' do
      let(:query) { 'think so -b 1 -a 2' }
      it { is_expected.to eq [%w[so think], { delta_before: 1.0, delta_after: 3.0, file_filter: nil }] }
    end

    context 'special chararacters' do
      let(:query) { "micheal's     bàchelor \"trauma!? -b 1.2 -a 2.4" }
      it { is_expected.to eq [%w[b chelor micheal s trauma], { delta_before: 1.2, delta_after: 3.6, file_filter: nil }] }
    end

    context 'with also filter option' do
      let(:query) { "micheal's  -f ad   bàchelor \"trauma!? -b 1.2 -a 2.4" }
      it { is_expected.to eq [%w[b chelor micheal s trauma], { delta_before: 1.2, delta_after: 3.6, file_filter: 'ad' }] }
    end

    context 'before and after time calculation' do
      let(:query) { "random search -b #{before} -a #{after}" }
      let(:before) { 0 }
      let(:after) { 0 }

      context 'when no before' do
        let(:after) { 5 }

        it { is_expected.to eq [%w[random search], { delta_before: 0, delta_after: 5, file_filter: nil }] }
      end

      context 'when before' do
        let(:before) { 5 }

        context 'when no after' do
          it { is_expected.to eq [%w[random search], { delta_before: 5, delta_after: 5, file_filter: nil }] }
        end

        context 'when after' do
          let(:after) { 5 }

          it { is_expected.to eq [%w[random search], { delta_before: 5, delta_after: 10, file_filter: nil }] }
        end
      end
    end
  end
end
