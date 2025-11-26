FactoryBot.define do
  factory :user do
    name { "John" }
    last_name { "Doe" }
    email { Faker::Internet.email }
    username { Faker::Internet.username(specifier: 3..20).gsub(/[^a-zA-Z0-9_]/, '_') }
    password { "password123" }
    role { :admin }
    status { :active }

    trait :salesperson do
      role { :salesperson }
    end

    trait :engineer do
      role { :engineer }
    end

    trait :inactive do
      status { :inactive }
    end
  end
end
