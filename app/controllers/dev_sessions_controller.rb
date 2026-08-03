# Development-only shortcut so the app is demoable before Firebase is wired.
class DevSessionsController < ApplicationController
  def create
    user = User.find(params[:id])
    sign_in(user)
    redirect_to dashboard_path, notice: "Dev signed in as #{user.display_name}."
  end
end
