class Project < ActiveRecord::Base
  belongs_to :topic

  has_many :assignments

  validates_presence_of :topic, :title, :description

  has_paper_trail

  # TODO: add a tagging system
end
