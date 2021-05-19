FactoryBot.define do
  factory :query_history do
    text { '' }
    time_before { 0 }
    time_after  { 0 }
    hits { 1 }
  end
end
