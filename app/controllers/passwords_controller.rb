class PasswordsController < ApiController
  skip_before_action :authorize_request, only: [:forgot, :reset]

  def forgot
    if params[:email].nil?
      return render json: {error: 'Email not present'}
    end
    user = User.find_by(email: params[:email].downcase)
    if user.present?
      user.generate_password_token!
      url = "#{request.base_url}/password/reset?token=#{user.reset_password_token}"
      UserMailer.password_reset(user, url).deliver_now
      render json: {password_token: user.reset_password_token, message: 'Reset password mail is sent to provided email Id'}, status: :ok
    else
      render json: {error: ['Email address not found. Please check and try again.']}, status: :not_found
    end
  end

  def edit_password
    
  end

  def reset
    token = params[:password_token].to_s
    user = User.find_by(reset_password_token: token)
    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:password])
        render json: {status: 'ok'}, status: :ok
      else
        render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {errors: ['The email link seems to be invalid. Try requesting for a new one.']}, status: :not_found
    end
  end

  def update
    if !params[:password].present?
      render json: {error: 'Password not present'}, status: :unprocessable_entity
      return
    end

    if current_user.reset_password(params[:password])
      render json: {status: 'ok'}, status: :ok
    else
      render json: {errors: current_user.errors.full_messages}, status: :unprocessable_entity
    end
  end

end
