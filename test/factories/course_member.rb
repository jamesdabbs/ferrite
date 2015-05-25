FactoryGirl.define do
  factory :course_member do
    course
    user
    role "student"
  end
end
