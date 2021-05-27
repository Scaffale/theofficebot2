FactoryBot.define do
  factory :choosen_result do
    uniq_id { 'MyString' }
    query_history { create(:query_history) }
  end
end
