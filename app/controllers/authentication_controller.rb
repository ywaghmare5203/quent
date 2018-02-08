class AuthenticationController < ApiController
	skip_before_action :authorize_request, only: :authenticate
  def authenticate
    auth_token = AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    if auth_token.present?
      render json: { auth_token: auth_token }
    else
      render json: { error: Message.invalid_credentials }, status: :unauthorized
    end
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end