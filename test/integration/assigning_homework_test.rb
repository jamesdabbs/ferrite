require 'test_helper'

class AssigningHomeworkTest < ActionDispatch::IntegrationTest
  def setup
    @course  = courses "DC-RoR"
    @student = @course.students.first!
  end

  test "creating a new project and assigning it" do
    login @course.instructor.user
    visit new_project_path

    select("Front End Engineering", from:'Topic')
    fill_in('Title', with:"Make Coffee")
    fill_in("Description", with:"First, get grounds. Next, pour over.") 
    click_button "Create Project"

    assert page.has_content?("Project created.")
    assert page.has_content?('First, get grounds')

    select(@course.organization, from:'Course')
    click_button("Create Assignment")

    login @student
    visit assignments_path
    assert page.has_content?("Make Coffee")
  end
end
