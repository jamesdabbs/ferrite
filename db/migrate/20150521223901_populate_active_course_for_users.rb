class User < ActiveRecord::Base
  def active_course_from_github
    @_active_course ||= Course.
      where(organization: github_client.organizations.map(&:login)).
      order(start_on: :desc).
      first
  end
end

class PopulateActiveCourseForUsers < ActiveRecord::Migration
  def up
    User.find_each do |u|
      u.active_course_id = u.active_course_from_github.try(:id)
      u.save! validate: false
    end
  end

  def down
    # No-op
  end
end
