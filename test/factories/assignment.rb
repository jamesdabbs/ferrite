FactoryGirl.define do
  factory :assignment do
    course
    project
    due_at { 3.days.from_now }
  end
end
