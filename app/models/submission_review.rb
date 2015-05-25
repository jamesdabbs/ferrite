class SubmissionReview < ActiveRecord::Base
  SCORE_RANGE = (1..5)

  belongs_to :reviewer, class_name: "User"
  belongs_to :submission

  validates_presence_of :reviewer, :submission, :score, :comments

  validates_inclusion_of :score, in: SCORE_RANGE

  after_initialize do
    self.comments ||= {}
  end

  def general_comments
    comments["general"]
  end
  def general_comments= c
    self.comments ||= {}
    self.comments.merge! "general" => c
  end
end
