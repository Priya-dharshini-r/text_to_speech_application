class ApplicationController < ActionController::Base
  def authenticate_user!
    header = request.headers["Authorization"]
    token = header&.split(" ")&.last
    decoded = JsonWebToken.decode(token)

    @current_user = User.find_by(id: decoded[:user_id]) if decoded
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end

  attr_reader :current_user
end