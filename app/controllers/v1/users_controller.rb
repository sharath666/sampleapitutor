class V1::UsersController < ::V1::ApplicationController
  before_action :authenticate_request, except: [:sign_up,:login]

    def login
       user = User.find_by(email: params[:email])
        if user.valid_password?(params[:password])
          render json: user.as_json(only: [:email,:authentication_token,:username])
        else
          head("Invalid Credentials")
        end
    end


    def user_booking_count_per_day
      current_date= DateTime.now.at_beginning_of_day
      end_date = DateTime.now.at_end_of_day
      unless @current_user.booking_slots.empty?
        booking_per_day = @current_user.booking_slots.where('date>=? and date<=?',current_date,end_date).count
      render json: {total_bookings:booking_per_day}
      else
        render json: {total_bookings:0}
      end
    end
    def user_booking_per_day
      current_date= DateTime.now.at_beginning_of_day
      end_date = DateTime.now.at_end_of_day
      unless @current_user.booking_slots.empty?
        booking_per_day = @current_user.booking_slots.where('date>=? and date<=?',current_date,end_date)
        
        render json:{total_bookings:booking_per_day.offset(3)}
      else
        render json:{total_bookings:[]}
      end
    end

    def users_booking_slot_count
      request_date = DateTime.parse(params[:date])
      @users = User.all
      @user_booking_count = {}
      @users.each do |user|
        @user_booking_count[user.email] = user.booking_slots.where('date=?', request_date).count
      end
      render json:@user_booking_count
    end

    def sign_up
      validate_user
      user = User.new(user_params)
      if @errors.empty? && user.valid?
        user.save
        render json: user
      else
        render json: @errors.merge(user.errors), status: :unprocessable_entity
      end
    end

    def logout 
    
      @user = @current_user
      @user.authentication_token == nil
      @user.save
      render json: {message:"You have successfully signed out"}
    end
private


def validate_user
    @errors = {}
    if params[:email].nil? || params[:email].empty?
      @errors[:email] = "Email field is requried"
    else
       if User.find_by_email(params[:email]).present?
        @errors[:email] = "Email already exist"
      end
    end
    if params[:password].nil? || params[:password].empty?
      @errors[:password] = "Password field is requried"
    end
    if params[:confirm_password].nil? || params[:confirm_password].empty?
      @errors[:confirm_password] = "confirm_password field is requried"
    elsif params[:password] != params[:confirm_password]
      @errors[:confirm_password] = "Password doesn't match"
    end 
    if params[:mobile].nil? || params[:mobile].empty?
      @errors["mobile"] = "mobile field is required"
    end
    if params[:username].nil? || params[:username].empty?
      @errors["username"] = "username field is required"
    end
    if params[:first_name].nil? || params[:first_name].empty?
      @errors["first_name"] = "firstname field is required"
    end
    if params[:last_name].nil? || params[:last_name].empty?
      @errors["last_name"] = "lastname field is required"
    end
  end




  def user_params
    params.permit(:email,:username,:password,:first_name,:last_name, :mobile,:role, :customer_type, :adhar_no,:adhar_image, :pan_no, :pan_image,:gst_no, :gst_image, :contact_person,:designation, :company_name)
  end
end

