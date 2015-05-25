class GithubSync
  attr_reader :client

  def initialize client
    @client = client
  end

  def pull_course_members course
    return unless course.organization

    gh_members = client.organization_members course.organization
    uids       = gh_members.map &:id
    users      = User.from_github_identities uids

    course.ensure_users_are_members users
  end
end
