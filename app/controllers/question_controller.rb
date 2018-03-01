class QuestionController < ApiController
  def index
    token = params[:token].to_s
    user = User.find_by(confirmation_token: token)
    if !user.present?
      render json: {error: Message.unauthorized}, status: :not_found
    else
      question = Question.eager_load(:option_catalogues).shuffle[0..4]
      if !question.present?
        render json: {error: "There is no question"}, status: :not_found
      else
      	render :json => question, :include => {:option_catalogues => {:only => [:id, :option_text , :question_id]}}, :except => [:created_at, :updated_at]
        #render json: Question.includes(:option_catalogues).all.to_json(:only =>  [:name]) #{interest: interest}, status: :ok
      end
    end
  end


  def ques_create
  	token = params[:token].to_s
    user = User.find_by(confirmation_token: token)
    if !user.present?
      render json: {error: Message.unauthorized}, status: :not_found
    else
    	question = Question.new
    	 if !(params[:question_media]).nil? 
	        question_media = params[:question_media].gsub!(" ", "+")
	        io = StringIO.new(Base64.decode64(question_media))
	        io.class.class_eval { attr_accessor :original_filename, :content_type }
	        io.original_filename = "question_media.jpg"
	        io.content_type = "image/jpg"
	        question.question_media = io
	      end
    	question.name = params[:name]

    	if question.save
    		render json: {status: :ok}
    	else
    		render json: {error: user_question.errors }, status: :bad
    	end
        
      end
  end

  def option_create
  	token = params[:token].to_s
    user = User.find_by(confirmation_token: token)
    if !user.present?
      render json: {error: Message.unauthorized}, status: :not_found
    else
    	options = OptionCatalogue.find_by(question_id: params[:question_id])
    	if options.present?
    		if !(params[:option_media]).nil? 
		      options_media = params[:option_media].gsub!(" ", "+")
		      io = StringIO.new(Base64.decode64(options_media))
		      io.class.class_eval { attr_accessor :original_filename, :content_type }
		      io.original_filename = "options_media.jpg"
		      io.content_type = "image/jpg"
		      options.update_attributes(:option_catalogues_media => io)
		    end
		   	options.update_attributes(option_text: params[:option_text],question_id: options.id)
		   	render json: {status: :ok}
	   	else
	   		render json: {error: options.errors }, status: :bad
    	end
      end
  end

  def create
  	token = params[:token].to_s
    user = User.find_by(confirmation_token: token)
    #if !user || !user.confirmation_token_valid?
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

    private
    	def user_answer_params
	  		params.permit(:user_id , :question_id, :option_catalogue_id)
	  	end
end
