class RegistrationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    user = User.new(
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )

    if user.save
      session[:user_id] = user.id
      render json: { id: user.id, email: user.email }
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
