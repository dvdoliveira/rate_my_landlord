#Helpers
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

# Homepage (Search box)

# Logout action and redirects logged out users to homepage
get '/logout' do
  session.clear
  redirect '/'
end

get '/' do
  erb :index
end

# Login form
get '/session/new' do
  erb :'session/new'
end

# Login and redirects users to homepage
post '/session' do
  user = User.where(email: params[:email]).first
  if user && user.password_hash == BCrypt::Engine.hash_secret(params[:password], user.password_salt)
    session[:user_id] = user.id
    session[:email] = user.email
    redirect '/'
  else
    set_error("Username not found or password incorrect.")
    erb :'/session/new'
  end
end

# Sign up form
get '/users/new' do
  @user = User.new
  erb :'users/new'
end

# Sign-up and redirects users to homepage
post '/users' do
  @user = User.new(
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
  if @user.save
    session[:user_id] = @user.id
    session[:email] = @user.email
    redirect '/'
  else
    erb :'users/new'
  end
end

# Index of landlords

get '/landlords' do
  @search_results = []
  if params[:name]
    name_array = params[:name].split(" ")
    subselect = name_array.map { |name| "SELECT * FROM landlords WHERE full_name LIKE '%#{name}%'" }.join(' UNION ALL ')
    query = "SELECT
              id,
              user_id,
              full_name,
              average_rating,
              friendly,
              COUNT(*) as rank
              FROM(#{subselect}) as landlords GROUP BY full_name ORDER BY rank DESC;"
    @search_results = Landlord.find_by_sql(query)

    @search_results.length == 1 ? (redirect "/landlords/#{@search_results.first.id}") : (erb :'landlords/index')
  elsif params[:street_number]
    address_of_landlord = Address.where(street_number: params[:street_number], street_name: params[:street_name], city: params[:city])

    address_of_landlord.each do |address|
      address.landlords.each do |landlord|
        @search_results << landlord
      end
    end
    erb :'landlords/index'
  elsif 
    @search_results = Landlord.all
    erb :'landlords/index'
  end
end

# Show form to create new landlord profile
get '/landlords/new' do
  erb :'/landlords/new'
end

# Show landlord profile page
get '/landlords/:id' do
  @landlord = Landlord.find(params[:id])
  erb :'landlords/show'
end

# Create new landlord and redirect user to landlord profiles
post '/landlords/' do
  @landlord = Landlord.create(user: current_user, full_name: params[:full_name])
  @address = Address.create(unit_number: params[:unit_number], street_number: params[:street_number], street_name: params[:street_name], city: params[:city])
  Rental.create(landlord: @landlord, address: @address)
  redirect "/landlords/#{@landlord.id}"
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
  @landlord = Landlord.find(params[:id])
  erb :'addresses/new'
end

# Create new address to a landlord and redirect user back to landlord profile
post '/landlords/:id/addresses' do
  Address.create(unit_number: params[:unit_number], street_number: params[:street_number], street_name: params[:street_name], city: params[:city])
  redirect "landlords/#{params[:landlord_id]}"
end