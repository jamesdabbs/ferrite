class SubmissionReview < ActiveRecord::Base
  SCORE_RANGE = (1..5)

  belongs_to :reviewer, class_name: "User"
  belongs_to :submission

  validates_presence_of :reviewer, :submission, :score, :comments

  validates_inclusion_of :score, in: SCORE_RANGE

  def self.max_score
    SCORE_RANGE.max
  end

  def general_comments
    comments["general"]
  end
end
