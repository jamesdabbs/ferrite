# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'active_record/fixtures'

fixture_path = Rails.root.join 'test', 'fixtures'
%w(campuses topics).each do |table|
  ActiveRecord::FixtureSet.create_fixtures fixture_path, table
end
