class AuthenticationController < ApiController
	skip_before_action :authorize_request, only: [:authenticate, :confirm_email]
  #before_action :validate_email_update, only: :update

  def authenticate
    user = User.find_by(email: params[:email].to_s.downcase)
    if user && user.authenticate(params[:password])
        auth_token = JsonWebToken.encode({user_id: user.id})
        user.update_attributes(:confirmation_token => auth_token)
        response = {user_id: user.id, username: user.username, name:user.name, email: user.email, provider:user.provider,device_id: user.device_id, auth_token:user.confirmation_token}
        render json: {user: response}, status: :ok
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
    token = params[:token].to_s
    user = User.find_by(confirmation_token: token)
    #if !user || !user.confirmation_token_valid?
    if !user.present?
      render json: {error: 'The email link seems to be invalid / expired. Try requesting for a new one.'}, status: :not_found
    else
      user.update_attributes(update_user_params)
      response = {user_id: user.id,username: user.username, name:user.name, email: user.email, provider:user.provider,device_id: user.device_id, auth_token:user.confirmation_token}
      render json: {user: response, status: 'User updated successfully'}, status: :ok
    end
  end

  def user_profile
    token = params[:token].to_s
    user = User.find_by(confirmation_token: token)

    if !user.present?
      render json: {error: Message.unauthorized}, status: :not_found
    else
      users = User.find_by(id: params[:user_id])
      if users.present?
        response = { user_id: users.id, username: users.username, name: users.name, email: users.email, provider:users.provider,device_id: users.device_id, auth_token: users.confirmation_token}
        render json: response, status: :ok
      else
        render json: {error: Message.user_page_not_found}, status: :not_found
      end
      
    end

  end

  def upload_media
    token = params[:token].to_s
    user = User.find_by(confirmation_token: token)
    #if !user || !user.confirmation_token_valid?
    if !user.present?
      render json: {error: 'The email link seems to be invalid / expired. Try requesting for a new one.'}, status: :not_found
    else
      if !(params[:profile_photo]).nil? 
        profile_photo = params[:profile_photo].gsub!(" ", "+")
        io = StringIO.new(Base64.decode64(profile_photo))
        io.class.class_eval { attr_accessor :original_filename, :content_type }
        io.original_filename = "profile_photo.jpg"
        io.content_type = "image/jpg"
        user.update_attributes(:profile_photo => io)
      end
      if !(params[:cover_photo]).nil?
        cover_photo = params[:cover_photo].gsub!(" ", "+")
        io = StringIO.new(Base64.decode64(profile_photo))
        io = StringIO.new(Base64.decode64(cover_photo))
        io.class.class_eval { attr_accessor :original_filename, :content_type }
        io.original_filename = "cover_photo.jpg"
        io.content_type = "image/jpg"
        user.update_attributes(:cover_photo => io)
    end
    if user.save
      response = {user_id: user.id,username: user.username, name:user.name, email: user.email, provider:user.provider,device_id: user.device_id, auth_token:user.confirmation_token, :profile_photo_url => User.profile_photo_url(user.profile_photo), :cover_photo_url => User.cover_photo_url(user.profile_photo)}
      render json: {user: response, status: 'User updated successfully'}, status: :ok
    else
      render json: {error: user.errors}, status: :bad_request
    end

      
    end
  end



  private
  def update_user_params
    params.permit(:name,:profile_photo,:cover_photo,:username,:provider,:username)
  end

  def auth_params
    params.permit(:email, :password, :device_id)
  end

  def validate_email_update
  @new_email = params[:email].to_s.downcase
  if @new_email.blank?
    return render json: { status: 'Email cannot be blank' }, status: :bad_request

  elsif (params[:email] == !current_user.email)
    return render json: { status: 'Current Email and New email cannot be the same' }, status: :bad_request

  elsif User.email_used?(@new_email, current_user.id)
    return render json: { error: 'Email is already in use.'}, status: :unprocessable_entity
  end

   
end
end