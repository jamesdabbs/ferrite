class SubmissionTable
  def initialize submissions
    @map, @users = {}, Set.new

    # Build a submissions map
    submissions.each do |s|
      @users << s.user
      @map[s.assignment_id] ||= {}
      @map[s.assignment_id][s.user_id] = s
    end

    # Standardize an ordering on users
    @users = @users.to_a

    # Grab the list of reviews
    @reviewed = Set.new SubmissionReview.where(submission: submissions).pluck(:submission_id)
  end

  def users
    @users
  end

  def row_for_assignment assignment
    subs = @map[assignment.id] || {}
    @users.map { |u| subs[u.id] }
  end

  def reviewed? submission
    @reviewed.include? submission.id
  end
end
