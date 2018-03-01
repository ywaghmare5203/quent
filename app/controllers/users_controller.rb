class UsersController < ApiController
	skip_before_action :authorize_request, only: :create
  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    user.confirmation_token = auth_token
    if user.save
      response = {user_id: user.id, username: user.username, name:user.name, email: user.email, provider:user.provider,device_id: user.device_id, auth_token:user.confirmation_token}
      url = "#{request.base_url}/confirm_email?token=#{user.confirmation_token}"
      UserMailer.welcome_email(user,url).deliver_now
      render json: {user: response, message: Message.account_created}, status: :created
    else
      response = { message: user.errors, status: :bad }
      render json: user.errors, status: :bad
    end 

  end

  private

  def user_params
    params.permit(:name,:email,:password,:password_confirmation,:profile_photo,:cover_photo,:username,:provider, :device_id)
  end
end
