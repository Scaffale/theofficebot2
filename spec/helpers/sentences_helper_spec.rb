require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SentencesHelper. For example:
#
# describe SentencesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SentencesHelper, type: :helper do
  it 'new line not time' do
    expect(time?("\n")).to be false
  end

  it 'random sentence not time' do
    expect(time?("This is the random's\n")).to be false
  end

  it 'new line is new line' do
    expect(new_line?("\n")).to be true
  end

  it 'random string is not new line' do
    expect(new_line?("random 'string $\n")).to be false
  end

  it 'time is time' do
    time = "00:18:46,326 --> 00:18:47,394\n"
    expect(time?(time)).to be true
  end

  it 'number is number' do
    expect(number?("1\n")).to be true
    expect(number?("12\n")).to be true
    expect(number?("123\n")).to be true
  end

  it 'not number is not number' do
    expect(number?("123$\n")).to be false
    expect(number?("$123\n")).to be false
  end

  # describe 'times' do
  #   it 'convert time' do
  #     time = '00:00:32,566'
  #     expect(extract_single_time(time)).to eq Time.parse('00:00:32,566')
  #   end

  #   it 'convert complex time' do
  #     time = '01:45:32,566'
  #     expect(extract_single_time(time)).to eq Time.parse('01:45:32,566')
  #   end
  # end

  describe 'sentences' do
    it 'read one sentence' do
      two_sentences = ["1\n",
                       "00:00:32,566 --> 00:00:33,534\n",
                       "All right, Jim,\n",
                       "\n",
                       "2\n",
                       "00:00:33,567 --> 00:00:36,304\n",
                       "your quarterlies\r\n",
                       "look very good.\n",
                       "\n"]
      two_sentences_check = [{ sentence: 'All right, Jim, ', time_start: '00:00:32,566', time_end: '00:00:33,534' },
                             { sentence: 'your quarterlies look very good. ', time_start: '00:00:33,567',
                               time_end: '00:00:36,304' }]
      expect(split_sentences(two_sentences)).to eq(two_sentences_check)
    end
  end
end
