require 'rails_helper'

RSpec.describe QueryHelper, type: :helper do
  it 'can extract option' do
    query = 'complex query -a 1 asdf'
    result = extract_number(query)
    expect(result).to eq 1
  end

  it 'can extract option' do
    query = 'complex query -a asdf'
    result = extract_number(query)
    expect(result).to eq 0
  end

  it 'can extract option' do
    query = 'complex query -a 10 asdf -a 4'
    result = extract_number(query)
    expect(result).to eq 10
  end

  it 'can extract option' do
    query = 'complex query -a asdf -a'
    result = extract_number(query)
    expect(result).to eq 0
  end

  it 'can extract option' do
    query = 'complex query -a 10 asdf -a 4 -b 234, asdf'
    result = extract_number(query)
    expect(result).to eq 10
    # result_b = extract_number(query)
    # expect(result_b).to eq 234
  end

  describe 'purge query' do
    it 'can purge from after' do
      query = 'complex query -a -20.5 and so'
      result = purge_query(query)
      expectation = ['complex query and so', { delta_before: 0, delta_after: -20.5 }]
      expect(result).to eq expectation
    end

    it 'can purge from after medium' do
      query = 'think so -b 1 -a 2'
      result = purge_query(query)
      expectation = ['think so ', { delta_before: 1.0, delta_after: 2.0 }]
      expect(result).to eq expectation
    end
  end
end
