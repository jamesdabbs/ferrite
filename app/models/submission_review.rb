class SubmissionReview < ActiveRecord::Base
  belongs_to :reviewer, class_name: "User"
  belongs_to :submission

  validates_presence_of :reviewer, :submission, :score, :comments
end
