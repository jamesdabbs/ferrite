module Teamwork
  class Sync
    def initialize client
      @client = client
    end

    def employees!
      warn "Syncing Employees from Teamwork authors ... "
      @client.authors.each { |author| sync_employee! author }
      warn "#{Employment.count} Employees"
      Employment.all
    end

private

    def sync_employee! author
      Employment.where(teamwork_id: author["id"]).first_or_create! do |e|
        e.email      = author["email-address"].downcase
        e.first_name = author["first-name"]
        e.last_name  = author["last-name"]
        e.user       = User.find_by_email e.email
      end
    rescue => e
      name = "#{author['first-name']} #{author['last-name']}".strip
      # FIXME: use logger, enable logger during seed load
      warn "Failed to sync '#{name}' - #{e}"
    end
  end
end
