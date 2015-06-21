# Helpers file used by actions.rb
helpers do

  # Keep user logged after sign-up anc checks if there is a current user
  def current_user
    if session[:user_id]
      if @current_user.nil?
        @current_user = User.find(session[:user_id])
      end
    end
    @current_user
  end

  # Error handling
  def display_error
    error = session[:error]
    session[:error] = nil
    if error
      return erb :'errors/error_display', locals: {errors: error}
    else
      return ""
    end
  end

  def set_error(msg)
    session[:error] = {"Error" => [msg]}
  end

end