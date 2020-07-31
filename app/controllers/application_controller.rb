class ApplicationController < ActionController::API
    private
    def authenticate_request
      @current_user = User.find_by_authentication_token(request.headers[:Authorization])
      render json: {error:'Not Authorize'}, status: 401 unless @current_user
    end
    
end
