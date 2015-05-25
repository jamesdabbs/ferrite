class RenameSlackTeamId < ActiveRecord::Migration
  def change
    rename_column :slack_team_memberships, :slack_team_id, :team_id
  end
end
