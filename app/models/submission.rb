class Submission < ActiveRecord::Base
  belongs_to :user
  belongs_to :assignment

  has_many :reviews, class_name: "SubmissionReview"

  validates_presence_of :user, :assignment, :repo, :comfort
  validates_inclusion_of :comfort, in: (1..5)

  def note_current_commit client
    update commit: client.commits(repo).first.sha
  end

  def link_to_github
    "https://github.com/#{repo}/tree/#{commit}"
  end
end
