class UsersController < ApiController
	skip_before_action :authorize_request, only: :create
  def create
    yes  = "iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAG8SURBVChTXVFNSJRRFD06ROAig9TB+XKMaeYzYdzYIjeRzUhItVBIykxbWIEbF4NBq2ipRlP0Q7hxJWK0KRkYRJzxp5UTmalBfwbTSJKLNg6ifNfTfZM2Qw8O797zznmcywXyp1jL6zV2+XS40ZsNN1rZGrssCRzsUr6oQJcrj9b6D78dHz1LJ32G/FlLZrx0PlXx1ZCbdvWBlGqsfZOr4WTZ++z3i9zd8gm/gvy8h296/wY3U8U8FcSCGlzGdO1W5wlOvbQk/ggSfwoZ64e8UJg6/gQyNQK50Qqq9ioCvtI30TuWaf6hpw3S3QIp4ORxBDzuwRwuNFk73PDyyKG8IDMB+fI633sqIEyDzfXYRtPp8m3+KuXkc0h7MyQa0ccVzb4MDvT+5aaHldN5QkE1+I+VzHGlhFwE1yf1YUPFHxRLCq1znJqZ1EgVmDVDd0w8K6KsgpfPwXl4G5JJQH4kwGgf5Mp5OLKkw9/NzdhuDC5/FRbWZvQXNQ1qpJuXFG1w7kfg7C5C1sb0dzfeqdYsN3cs24NU7IGaTP6Pe5Hmwdg90HZjXjWe/7dt+s6AG8lQHbIGgUokzJ4KhX8ADmPpjZq+R8YAAAAASUVORK5CYII="

    if yes == params[:profile_photo]
      puts "DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD#{params[:profile_photo]}"
      else
        puts "NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN#{params[:profile_photo].inspect}"
        puts "YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY#{yes.inspect}"
    end
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    if params[:profile_photo].present?
      User.profile_photo(params[:profile_photo])
    elsif params[:cover_photo].present?
      User.cover_photo(params[:cover_photo])
      #io = StringIO.new(Base64.decode64(params[:profile_photo])
      #io.class.class_eval { attr_accessor :original_filename, :content_type }
      #io.original_filename = "profile_photo.jpg"
      #io.content_type = "image/jpg"
      #puts "idOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO#{io.inspect}"
      #user.profile_photo = io
    else
    end
        
    
    #user.profile_photo = io
    
    if user.save
      response = { message: Message.account_created, auth_token: auth_token }
      UserMailer.welcome_email(user).deliver_now
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
