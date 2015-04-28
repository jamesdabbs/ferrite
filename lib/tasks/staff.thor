class Staff < Thor
  desc "import", "import from Teamwork"
  def import
    require_relative "../../config/environment"
    Teamwork.sync.employees!
  end
end
