FactoryBot.define do
  factory :service do
    code { "SER-001" }
    title { "Test Service" }
    description { "Service Description" }
    unit { :hour }
    suggested_price { 50.00 }
    public_price { 75.00 }
    category { :installation }
  end
end
