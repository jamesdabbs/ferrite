class Topic < ActiveRecord::Base
  has_many :courses
  has_many :projects

  validates :title, presence: true, uniqueness: true
end
