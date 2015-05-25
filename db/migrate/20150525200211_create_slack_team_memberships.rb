class CreateSlackTeamMemberships < ActiveRecord::Migration
  def change
    create_table :slack_team_memberships do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :slack_team, index: true, foreign_key: true
      t.string :username, index: true, unique: true

      t.timestamps null: false
    end
  end
end
