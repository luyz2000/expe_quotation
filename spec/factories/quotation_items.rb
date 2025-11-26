FactoryBot.define do
  factory :quotation_item do
    quotation { nil }
    item_type { :material }
    description { "Item Description" }
    quantity { 1.0 }
    unit { :piece }
    unit_price { 100.00 }
    amount { 100.00 }
    currency { :usd }
  end
end
