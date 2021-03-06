class Campus < ActiveRecord::Base
  has_many :courses

  validates :name, presence: true, uniqueness: true

  def admin_label
    name
  end
end
