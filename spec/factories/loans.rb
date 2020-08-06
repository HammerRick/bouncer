FactoryBot.define do
  factory :loan do
    name { "MyString" }
    cpf { "MyString" }
    birthdate { "2020-08-05" }
    amount { "9.99" }
    terms { 1 }
    income { "9.99" }
  end
end
