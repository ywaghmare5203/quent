class InterestController < ApiController
  ##skip_before_action :authorize_request, only: [:index]
  def create
  	token = params[:token].to_s
    user = User.find_by(confirmation_token: token)
    if !user.present?
      render json: {error: Message.unauthorized}, status: :not_found
    else
    	user_interest_id = params[:interest_id].split(",")
    	user_interest_id.each do |interest|
    		user_interest = UserInterest.new
    		user_interest.interest_id = interest.to_i
    		user_interest.user_id = params[:user_id]
    		user_interest.save
    	end
        render json: {message: "Your Interest Successfully Added"}, status: :ok
      end
    end

  def index
    token = params[:token].to_s
    user = User.find_by(confirmation_token: token)
    if !user.present?
      render json: {error: Message.unauthorized}, status: :not_found
    else
      interest = Interest.all
      if !interest.present?
        render json: {error: "There is no Interest"}, status: :not_found
      else
        render json: Interest.all.to_json(:only =>  [:id, :name,:description], :methods => [:imedia_url]) #{interest: interest}, status: :ok
      end
    end
  end

  private

  	def user_interest_params
  		params.permit(:user_id , :interest_id)
  	end
end
