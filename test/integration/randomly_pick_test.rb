require 'test_helper'

class RandomPickTest < ActionDispatch::IntegrationTest
  def setup
    # TODO Should I use fixtures now? 
    # TODO How to test randomness?
    @course = FactoryGirl.create :course
    @instructor = @course.instructor.user
    @student = FactoryGirl.create :user
    FactoryGirl.create :course_member, course: @course, user: @student
  end

  test "random_pick shows a student" do
    login @instructor
    visit course_path(@course)
    click_on "Volunteer"
    # TODO Why does 'click_on' work here, but not 'click_button'?
    assert page.has_content?("has been randomly chosen")
  end

  test "random_pick increments a students' picks" do
    # TODO Where should this test go?
    # Is this a unit test?
  end

  test "random_pick only chooses students'" do
  end

  test "random_pick is (semi-)random" do
  end

end