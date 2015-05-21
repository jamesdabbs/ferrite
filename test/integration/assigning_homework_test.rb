require 'test_helper'

class AssigningHomeworkTest < ActionDispatch::IntegrationTest
  test "creating a new project and assigning it" do
    instructor = FactoryGirl.create :user, :instructor
    login instructor
    visit new_project_path
    # Fill in form
    # Save
    # Create assignment

    # Can see assignment
    # Login as student in course
    # Can see assignment
  end
end
