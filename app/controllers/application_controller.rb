class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def current_user
    @current_user ||= begin
      if session[:user_id]
        User.find_by(id: session[:user_id])
      else
        user = User.create!(email: "guest_#{SecureRandom.uuid}@example.com")
        session[:user_id] = user.id
        user
      end
    end
  end
end
