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

  # Method to escape HTML on form fields and avoid Cross Site Scripting
  def h(text)
    Rack::Utils.escape_html(text)
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

  def display_error_comment
    error = session[:error]
    session[:error] = nil
    if error
      return erb :'errors/error_display_comment', locals: {errors: error}
    else
      return ""
    end
  end
end