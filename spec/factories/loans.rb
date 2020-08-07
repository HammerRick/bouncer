FactoryBot.define do
  factory :loan do
    sequence(:name) { |n| "User Name ##{n}" }
    sequence(:cpf, 10_000_000_000) { |n| n.to_s }
    birthdate { '2020-08-05' }
    amount { '9.99' }
    terms { [6, 9, 12].sample }
    income { '9.99' }
  end
end
