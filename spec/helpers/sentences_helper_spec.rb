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
      two_sentences_check = [{ sentence: 'all right jim', time_start: '00:00:32,566', time_end: '00:00:33,534' },
                             { sentence: 'your quarterlies look very good', time_start: '00:00:33,567',
                               time_end: '00:00:36,304' }]
      expect(split_sentences(two_sentences)).to eq(two_sentences_check)
    end

    let(:file_sample) do
      "1
00:00:04,911 --> 00:00:06,608
<i>Questo e' Michael Bluth.</i>

2
00:00:05,637 --> 00:00:08,620
{\pos(190,210)}MICHAEL BLUTH Michael
Manager della Bluth Company

3
00:00:06,900 --> 00:00:11,042
<i>Per dieci anni ha lavorato nell'azienda di
suo padre, aspettandosi di diventarne socio.</i>

4
00:00:11,072 --> 00:00:13,526
<i>E in questo momento e' felice.</i>

5
00:00:14,330 --> 00:00:16,844
<i>- Questa e' la madre di Michael.</i>
- Guarda cosa hanno fatto, Michael.

6
00:00:16,874 --> 00:00:18,224
<i>Lei non e' felice.</i>

7
00:00:16,874 --> 00:00:18,224
{\pos(190,210)}LUCILLE BLUTH
Membro dell'alta societa'

8
00:00:18,809 --> 00:00:21,509
Guarda cosa mi hanno
fatto gli omosessuali.

9
00:00:21,789 --> 00:00:24,532
Non puoi prendere una spazzola
e risistemarti i capelli?

10
00:00:24,562 --> 00:00:27,121
<i>E' infastidita perche' la festa per
il pensionamento di suo marito</i>
".split("\n")
    end
    it 'read many sentence' do
      two_sentences_check = [
        { sentence: 'questo e michael bluth', time_start: '00:00:04,911', time_end: '00:00:06,608' },
        { sentence: 'michael bluth manager della company', time_start: '00:00:05,637',
          time_end: '00:00:08,620' },
        { sentence: 'per dieci anni ha lavorato nell azienda di suo padre aspettandosi diventarne socio',
          time_start: '00:00:06,900', time_end: '00:00:11,042' },
        { sentence: 'e in questo momento felice', time_start: '00:00:11,072', time_end: '00:00:13,526' },
        { sentence: 'questa e la madre di michael guarda cosa hanno fatto',
          time_start: '00:00:14,330', time_end: '00:00:16,844' },
        { sentence: 'lei non e felice', time_start: '00:00:16,874', time_end: '00:00:18,224' },
        { sentence: 'lucille bluth membro dell alta societa', time_start: '00:00:16,874',
          time_end: '00:00:18,224' },
        { sentence: 'guarda cosa mi hanno fatto gli omosessuali', time_start: '00:00:18,809',
          time_end: '00:00:21,509' },
        { sentence: 'non puoi prendere una spazzola e risistemarti i capelli', time_start: '00:00:21,789',
          time_end: '00:00:24,532' },
        { sentence: 'e infastidita perche la festa per il pensionamento di suo marito',
          time_start: '00:00:24,562', time_end: '00:00:27,121' }
      ]
      expect(split_sentences(file_sample)).to eq(two_sentences_check)
    end
  end

  context 'when long file' do
    context 'when special file' do
      let(:long_file) do
        File.open(Rails.root.join('spec', 'data', 'ArrestedDevelopment_s01_e12.srt'), 'r:ISO-8859-1:UTF-8')
      end
      it 'can read all sentences' do
        expect(split_sentences(long_file).size).to eq 463
      end
    end
  end

  context 'uniq_id' do
    subject { uniq_id(name_to_change) }

    context 'when long name' do
      let(:name_to_change) { 'The.Lord.of.the.Rings.The.Fellowship.of.the.Ring_it-005606668-000005291-.mp4' }

      it 'should cut correctly' do
        expect(subject).to eq '.of.the.Ring_it-005606668-000005291'
      end
    end

    context 'when short name' do
      let(:name_to_change) { 's01e01-005606668-000005291-.mp4' }

      it 'should cut correctly' do
        expect(subject).to eq 's01e01-005606668-000005291-.mp4'
      end
    end
  end

  describe '#purge_and_split' do
    subject { purge_and_split(sentence) }

    context 'when nothing to purge' do
      let(:sentence) { 'Non puoi prendere una spazzola e risistemarti i capelli' }

      it { is_expected.to eq %w[non puoi prendere una spazzola e risistemarti i capelli] }
    end
    context 'when to purge' do
      context 'when many to purge' do
        let(:sentence) { "{pos(190,210)}<i>E' infastidita perche' la festa per il <b>pensionamento</b> di suo marito</i>" }
        it { is_expected.to eq %w[e infastidita perche la festa per il pensionamento di suo marito] }
      end

      context 'when <i> and <b> to remove' do
        let(:sentence) { "<i>E' infastidita perche' la festa per il <b>pensionamento</b> di suo marito</i>" }
        it { is_expected.to eq %w[e infastidita perche la festa per il pensionamento di suo marito] }

        context 'when only one' do
          let(:sentence) { "<i>E' infastidita perche' la festa per il pensionamento di suo marito</i>" }
          it { is_expected.to eq %w[e infastidita perche la festa per il pensionamento di suo marito] }
        end
      end
    end
  end
end
