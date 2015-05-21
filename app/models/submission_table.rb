class SubmissionTable
  def initialize submissions
    @map, @users = {}, Set.new

    submissions.each do |s|
      @users << s.user
      @map[s.assignment_id] ||= {}
      @map[s.assignment_id][s.user_id] = s
    end

    @users = @users.to_a
  end

  def users
    @users.map &:name
  end

  def row_for_assignment assignment
    subs = @map[assignment.id] || {}
    @users.map { |u| subs[u.id] }
  end
end
