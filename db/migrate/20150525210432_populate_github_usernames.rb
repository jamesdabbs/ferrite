class User < ActiveRecord::Base
  has_many :identities
end

class Identity < ActiveRecord::Base
  belongs_to :user
end

class PopulateGithubUsernames < ActiveRecord::Migration
  def up
    Identity.where(provider: "github").find_each do |i|
      u = i.user
      u.github_username = i.data["info"]["nickname"]
      u.save! validate: false
    end
  end

  def down
    # No-op
  end
end
