require 'test_helper'

class SubmittingHomeworkTest < ActionDispatch::IntegrationTest
  def setup
    @course     = courses "DC-RoR"
    @instructor = @course.instructor.user
    @student    = @course.students.first!

    @assignment = FactoryGirl.create :assignment, course: @course
  end

  test "student is a student in this course" do
    assert_predicate @student, :student?
    assert_includes  @course.members, @student
  end

  test "students can submit homework" do
    stub_request(:get, /api.github.com/).to_return(body: [
      Hashie::Mash.new(full_name: "rails/rails", name: "rails")
    ])

    login @student

    visit assignment_path @assignment

    within "#new_submission" do
      select "rails", from: "Repo"
      select "3",     from: "Comfort"
      click_button "Create Submission"
    end

    # Student can see the submission
    assert page.has_content? "less than a minute ago"

    @submission = @student.submissions.last

    # Instructor received notification
    msg = last_slack_message
    assert_equal msg.to.user, @course.instructor.user
    assert_match /new submission/i, msg.body
    assert_includes msg.body, submission_path(@submission)

    # Instructor can view the submission
    login @instructor
    visit submission_path @submission

    link = page.find_link @submission.repo
    assert_equal @submission.link_to_github, link["href"]
    assert page.has_content? @submission.comfort
  end
end
