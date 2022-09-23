require 'faker'

FactoryBot.define do
  factory :bulk_discount do
    discount { Faker::Number.between(from: 1, to: 100) }
    threshold { Faker::Number.between(from: 5, to: 1000) }
    merchant
  end
end 