class AddTimeZoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :time_zone, :string, null: false, default: "Eastern Time (US & Canada)"
  end
end
