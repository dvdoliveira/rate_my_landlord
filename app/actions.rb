
# Helpers
# helpers do
#   def current_user
#     if session[:user_id]
#       if @current_user.nil?
#         @current_user = User.find(session[:user_id])
#       end
#     end
#     @current_user
#   end
# end

# Homepage (Search box)
get '/' do
  erb :index
end

# Login form
get '/session/new' do
  erb :'session/new'
end

# Login and redirects users to homepage
post '/session' do
  redirect '/'
end

# Sign up form
get '/users/new' do
  # @user = User.new
  erb :'users/new'
end

# Sign-up and redirects users to homepage
post '/users' do
  if params[:password] == params[:password_confirmation]
    user = User.create(
      email: params[:email],
      password_hash: params[:password_hash],
      password_salt: params[:password_salt]
    )
    binding.pry
    session[:user_id] = user.id
    session[:email] = user.email
    redirect '/'
  else
    redirect '/users/new'
  end
end

# Logout action and redirects logged out users to homepage
delete '/session' do
  session.clear
  redirect '/'
end

# Index of landlords
get '/landlords' do
  erb :'landlords/index'
end

# Show landlord profile page
get '/landlords/:id' do
  erb :'landlords/show'
end

# Show form to create new landlord profile
get '/landlords/new' do
  erb :'landlords/new'
end

# Create new landlord and redirect user to landlord index
post '/landlords' do
  #TODO
end

# Show form to create new rating
get '/landlords/:id/ratings/new' do
  erb :'ratings/new'
end

# Create new landlord and redirect user to landlord profile
post '/landlords/:id/ratings' do
  #TODO
end

# Show form to create new address
get '/landlords/:id/addresses/new' do
  erb :'addresses/new'
end

# Create new address to a landlord and redirect user back to landlord profile
post '/landlordds/:id/addresses' do
  #TODO
end



