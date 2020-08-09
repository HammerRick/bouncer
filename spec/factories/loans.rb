FactoryBot.define do
  factory :loan do
    sequence(:name) { |n| "User Name ##{n}" }
    sequence(:cpf, 10_000_000_000) { |n| n.to_s }
    birthdate { Date.today - rand(17.years..19.years) }
    amount { '3000.40' }
    terms { [6, 9, 12].sample }
    income { '1200.55' }
  end
end
