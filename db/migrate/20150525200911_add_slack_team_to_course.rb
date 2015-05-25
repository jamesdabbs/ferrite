class AddSlackTeamToCourse < ActiveRecord::Migration
  def change
    add_reference :courses, :slack_team, index: true, foreign_key: true
  end
end
