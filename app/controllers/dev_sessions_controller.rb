# Local sign-in when Firebase isn't set up yet.
class DevSessionsController < ApplicationController
  def create
    user = User.find(params[:id])
    sign_in(user)
    redirect_to dashboard_path, notice: "Dev signed in as #{user.display_name}."
  end
end
