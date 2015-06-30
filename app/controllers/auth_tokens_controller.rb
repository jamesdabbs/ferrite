class AuthTokensController < ApplicationController
  def create
    token = current_user.auth_tokens.new
    authorize token
    token.save!
    redirect_to :back, notice: "New auth token created"
  end

  def destroy
    token = current_user.auth_tokens.find params[:id]
    authorize token
    token.expire!
    redirect_to :back, notice: "Token expired"
  end
end
