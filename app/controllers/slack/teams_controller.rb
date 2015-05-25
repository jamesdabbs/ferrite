class Slack::TeamsController < ApplicationController
  def index
    @teams = policy_scope Slack::Team
  end

  def create
    team = Slack::Team.new create_params
    authorize team
    if team.save
      flash[:notice] = "Team created"
    else
      flash[:danger] = "Error saving team - #{team.errors.full_messages.to_sentence}"
    end
    redirect_to :back
  end

private

  def create_params
    params.require(:slack_team).permit :name, :webhook_url
  end
end
