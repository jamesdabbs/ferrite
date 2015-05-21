class User < ActiveRecord::Base
end

class PopulateNameFromIdentities < ActiveRecord::Migration
  def up
    User.find_each do |u|
      begin
        u.name = u.identities.first.data["info"]["name"]
        u.save! validate: false
      rescue NoMethodError # for nil
      end
    end
  end

  def down
    # (nothingtodohere)
  end
end
