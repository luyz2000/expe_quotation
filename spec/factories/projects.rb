FactoryBot.define do
  factory :project do
    folio_number { "PF-001" }
    name { "Test Project" }
    description { "Project Description" }
    client { nil }
    responsible { nil }
    location { "Project Location" }
    project_type { :construction }
    status { :planned }
    start_date { Date.current }
    estimated_end_date { Date.current + 60.days }
    actual_end_date { nil }

    # Create associated client and responsible user by default if not provided
    transient do
      with_client_and_responsible { false }
    end

    after(:build) do |project, evaluator|
      if evaluator.with_client_and_responsible
        project.client ||= create(:client)
        project.responsible ||= create(:user)
      end
    end
  end
end
