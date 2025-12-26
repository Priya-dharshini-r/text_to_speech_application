class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def current_user
    @current_user ||= begin
      if session[:user_id]
        User.find(session[:user_id])
      else
        user = User.create!(
          email: "guest_#{SecureRandom.uuid}@example.com"
        )
        session[:user_id] = user.id
        user
      end
    end
  end
end