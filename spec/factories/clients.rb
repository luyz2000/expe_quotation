FactoryBot.define do
  factory :client do
    company_name { "Test Client" }
    tax_id { "RFC123456789" }
    contact_name { "John Doe" }
    contact_email { "john@example.com" }
    contact_phone { "555-1234" }
    address { "123 Main Street" }
    city { "Anytown" }
    state { "Any State" }
    client_type { :industrial }

    trait :residential do
      client_type { :residential }
    end

    trait :governmental do
      client_type { :governmental }
    end
  end
end
