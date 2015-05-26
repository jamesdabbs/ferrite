require 'test_helper'

class AssigningHomeworkTest < ActionDispatch::IntegrationTest
  def setup
    @course = FactoryGirl.create :course
    @instructor = @course.instructor.user
    @student = FactoryGirl.create :user
    FactoryGirl.create :course_member, course: @course, user: @student
  end

  test "creating a new project and assigning it" do
    login @instructor
    visit new_project_path
    select("Front End Engineering", from:'Topic')
    fill_in('Title', with:"Make Coffee")
    fill_in("Description", with:"First, get grounds. Next, pour over.") 
    click_button "Create Project"
    assert page.has_content?("Project created.")
    @project = Project.last
    assert page.has_content?('First, get grounds')
    select(@course.organization, from:'Course')
    click_button("Create Assignment")
    assert page.has_content?("")
    @assignment = Assignment.last
    login @student
    assert page.has_content?("First, get grounds.")
  end
end
