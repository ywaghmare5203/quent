class UsersController < ApiController
	skip_before_action :authorize_request, only: :create
  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    if user.save
      response = { message: Message.account_created, auth_token: auth_token }
      UserMailer.welcome_email(user).deliver_now
      render json: response, status: :created 
    else
      render json: @user.errors, status: :bad
    end 

  end

  private

  def user_params
    params.permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end
end
