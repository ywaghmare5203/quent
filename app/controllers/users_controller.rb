class UsersController < ApiController
	skip_before_action :authorize_request, only: :create
  def create
    user = User.create!(user_params)
    #auth_token = AuthenticateUser.new(user.email, user.password).call
    if params[:profile_photo].present?
      io = StringIO.new(Base64.decode64(params[:profile_photo]))
      io.class.class_eval { attr_accessor :original_filename, :content_type }
      io.original_filename = "profile_photo.jpg"
      io.content_type = "image/jpg"
      user.profile_photo = io
    elsif params[:cover_photo].present?
      io = StringIO.new(Base64.decode64(params[:cover_photo]))
      io.class.class_eval { attr_accessor :original_filename, :content_type }
      io.original_filename = "profile_photo.jpg"
      io.content_type = "image/jpg"
      user.cover_photo = io
    else
    end
   
    if user.save
      response = { message: Message.account_created}
      url = "#{request.base_url}/confirm_email?token=#{user.confirmation_token}"
      UserMailer.welcome_email(user,url).deliver_now
      render json: response, status: :created 
    else
      response = { message: user.errors, status: :bad }
      render json: user.errors, status: :bad
    end 

  end

  private

  def user_params
    params.permit(:name,:email,:password,:password_confirmation,:profile_photo,:cover_photo,:username,:provider)
  end
end
