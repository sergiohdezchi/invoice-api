FactoryBot.define do
  factory :invoice do
    invoice_number { "C#{Faker::Number.unique.number(digits: 5)}" }
    invoice_date { Date.today }
    total { 10.0 }
    status { 'Vigente' }
  end
end
