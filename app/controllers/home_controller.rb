class HomeController < ApplicationController
  def index
    # Allow access without authentication for the home page
    # This can be customized based on your requirements
    redirect_to clients_path if user_signed_in?
  end
end
