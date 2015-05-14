class Submission < ActiveRecord::Base
  belongs_to :user
  belongs_to :assignment

  has_many :reviews, class_name: "SubmissionReview"

  validates_presence_of :user, :assignment, :repo, :commit, :comfort
end
