FactoryBot.define do
  factory :attachment do
    file { "MyString" }
    attachable_type { "MyString" }
    attachable_id { 1 }
    file_size { 1 }
    file_type { "MyString" }
    original_filename { "MyString" }
  end
end
