class AuthenticationController < ApiController
	skip_before_action :authorize_request, only: [:authenticate, :confirm_email]

  def authenticate
    user = User.find_by(email: params[:email].to_s.downcase)
    puts "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSTTTTTTTTTTTTTTTTTTTTTTRRRRRRRRRRRRRR#{user.authenticate(params[:password]).inspect}"
    if user && user.authenticate(params[:password])
      if user.confirmed_at?
        auth_token = JsonWebToken.encode({user_id: user.id})
        render json: {auth_token: auth_token}, status: :ok
      else
        render json: {error: 'Email not verified' }, status: :unauthorized
      end
    else
      render json: {error: Message.invalid_credentials}, status: :unauthorized
    end
  end

  def confirm_email
    confirm(params[:token])
  end

  def confirm(token)
    user = User.find_by(confirmation_token: token.to_s)

    if user.present?
      user.mark_as_confirmed!
      render json: {status: 'User confirmed successfully'}, status: :ok
    else
      render json: {status: 'Invalid token'}, status: :not_found
    end
  end

  def update
    if current_user.update_new_email!(@new_email)
      # SEND EMAIL HERE
      render json: { status: 'Email Confirmation has been sent to your new Email.' }, status: :ok
    else
      render json: { errors: current_user.errors.values.flatten.compact }, status: :bad_request
    end
  end

  def email_update
    token = params[:token].to_s
    user = User.find_by(confirmation_token: token)

    if !user || !user.confirmation_token_valid?
      render json: {error: 'The email link seems to be invalid / expired. Try requesting for a new one.'}, status: :not_found
    else
      user.update_new_email!
      render json: {status: 'Email updated successfully'}, status: :ok
    end
  end

  private

  def auth_params
    params.permit(:email, :password)
  end

  def validate_email_update
  @new_email = params[:email].to_s.downcase

  if @new_email.blank?
    return render json: { status: 'Email cannot be blank' }, status: :bad_request
  end

  if  @new_email == current_user.email
    return render json: { status: 'Current Email and New email cannot be the same' }, status: :bad_request
  end

  if User.email_used?(@new_email)
    return render json: { error: 'Email is already in use.'}, status: :unprocessable_entity
  end
end
end