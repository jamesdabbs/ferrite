class UserRole < ActiveRecord::Base
  validates_presence_of :user, :role
  validates_uniqueness_of :role, scope: :user
end
