class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    id_token = params.require(:id_token)
    payload = Firebase::IdTokenVerifier.verify!(id_token)
    user = Users::FindOrCreateFromFirebase.call(payload)
    sign_in(user)

    render json: { ok: true, redirect_to: after_sign_in_path }
  rescue Firebase::IdTokenVerifier::InvalidToken => e
    render json: { ok: false, error: e.message }, status: :unauthorized
  rescue Firebase::IdTokenVerifier::Error => e
    render json: { ok: false, error: e.message }, status: :service_unavailable
  end

  def destroy
    sign_out
    redirect_to root_path, notice: "Signed out."
  end

  private

  def after_sign_in_path
    params[:return_to].presence || dashboard_path
  end
end
