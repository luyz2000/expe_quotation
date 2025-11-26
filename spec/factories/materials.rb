FactoryBot.define do
  factory :material do
    code { "MAT-001" }
    title { "Test Material" }
    description { "Material Description" }
    unit { :piece }
    cost_price { 10.00 }
    public_price { 15.00 }
    category { :electrical }
  end
end
