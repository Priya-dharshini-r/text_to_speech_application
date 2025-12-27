class SessionsController < ApplicationController

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: { id: user.id, email: user.email } }
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  def destroy
    reset_session
    render json: { message: "Logged out" }
  end

  def me
    if current_user
      render json: { id: current_user.id, email: current_user.email }
    else
      render json: { error: "Not authenticated" }, status: :unauthorized
    end
  end
end
