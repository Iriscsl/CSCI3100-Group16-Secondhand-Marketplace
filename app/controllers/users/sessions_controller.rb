class Users::SessionsController < Devise::SessionsController
  def create
    super do |user|
      if user.persisted?
        session[:notice] = "Welcome back, #{user.name || user.email}!"
      end
    end
  end
    
  def destroy
    super do |resource|
      flash[:notice] = "You have been signed out successfully."
    end
  end
end