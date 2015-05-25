class CreateSlackTeams < ActiveRecord::Migration
  def change
    create_table :slack_teams do |t|
      t.string :name
      t.string :webhook_url

      t.timestamps null: false
    end
  end
end
