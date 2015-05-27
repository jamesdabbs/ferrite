class CourseMember < ActiveRecord::Base
  Roles = %w( student assistant instructor )

  belongs_to :course
  belongs_to :user

  validates_presence_of :course, :user, :role
  validates_inclusion_of :role, in: Roles

  def notify_of_submission_review submission_review
    return unless true #This should check to make sure they have a slack id
    submission_review_url = Rails.application.routes.url_helpers.submission_review_url submission_review
    message = Slack::Message.new(
      to: MEMBER,
      body: "#{@submission_review} has reviewed your submission #{@submission_review.submission}.
      Visit #{submission_review_url} to see comments."
    )
    message.deliver
  end
end
