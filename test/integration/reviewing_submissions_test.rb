require 'test_helper'

class ReviewingSubmissionsTest < ActionDispatch::IntegrationTest
  def setup
    @course      = courses "DC-RoR"
    # TODO: clean this up by fixturing an assignment and course members
    @assignment  = FactoryGirl.create :assignment, course: @course
    @submissions = 2.times.map do
      s = FactoryGirl.create :submission, assignment: @assignment
      FactoryGirl.create :slack_team_membership, team: @course.slack_team, user: s.user
      s
    end
  end

  test "instructors can review any submission for an assignment" do
    login @course.instructor.user
    visit assignment_path @assignment

    @submissions.each do |submission|
      assert page.has_content? submission.user.name
    end

    submission = @submissions.first
    view = find :link_to, submission_path(submission)
    view.click

    assert page.has_content? submission.comments
    find :link_to, submission.link_to_github

    select "5", from: "Score"
    fill_in "General comments", with: "Good Job!"
    click_on "Create Submission review"

    assert page.has_content? "Review saved"
    assert page.has_content? "Good Job!"

    msg = last_slack_message
    assert_equal @course.slack_team.membership_for(submission.user), msg.to
    assert_match /new review/i, msg.body
    assert_includes msg.body, submission_path(submission)
  end

  test "students only see their submissions" do
    vcr do
      submission = @submissions.first
      login submission.user
      visit assignment_path submission.assignment

      find :link_to, submission_path(submission)
      assert_raises Capybara::ElementNotFound do
        find :link_to, submission_path(@submissions.last)
      end
    end
  end

  test "students cannot create reviews" do
    # by POST'ing in. Also, if unauthenticated ...
    skip
  end
end
