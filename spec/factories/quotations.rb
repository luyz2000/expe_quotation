FactoryBot.define do
  factory :quotation do
    quotation_number { "QT-001" }
    project { nil }
    client { nil }
    salesperson { nil }
    project_type { :high_voltage }
    publish_date { Date.current }
    expiry_date { Date.current + 30.days }
    subtotal { 1000.00 }
    total { 1200.00 }
    status { :draft }
    terms_conditions { "Standard terms and conditions" }
    notes { "Additional notes" }
    revision_number { 1 }
  end
end
