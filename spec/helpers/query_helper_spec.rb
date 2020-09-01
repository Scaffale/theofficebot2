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
end
