require 'test_helper'

class SubmittingHomeworkTest < ActionDispatch::IntegrationTest
  def setup
    @course     = FactoryGirl.create :course, :with_slack_team
    @instructor = @course.instructor.user

    @instructor_slack = FactoryGirl.create :slack_team_membership,
      user: @instructor, team: @course.slack_team

    @assignment = FactoryGirl.create :assignment, course: @course

    @student = FactoryGirl.create :user, github_username: "rails"
    # TODO: this should live elsewhere
    FactoryGirl.create :course_member, course: @course, user: @student
  end

  test "student is a student in this course" do
    assert_predicate @student, :student?
    assert_includes  @course.members, @student
  end

  # TODO: don't actually make calls to Github here
  test "students can submit homework" do
    vcr do
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
      assert_equal msg.to, @instructor_slack
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
end
