require_relative './helpers'

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
  if params[:name] && !params[:name].empty?
    name_array = params[:name].split(" ")
    subselect = name_array.map { |name| "SELECT * FROM landlords WHERE full_name LIKE '%#{name}%'" }.join(' UNION ALL ')
    query = "SELECT
              id,
              user_id,
              full_name,
              average_rating,
              average_communication,
              average_reliability,
              average_helpfulness,
              friendly,
              created_at,
              COUNT(*) as rank
              FROM(#{subselect}) as landlords GROUP BY id ORDER BY rank DESC;"
    @search_results = Landlord.find_by_sql(query)
    @search_results.length == 1 ? (redirect "/landlords/#{@search_results.first.id}") : (erb :'landlords/index')
  else params[:street_number] && !params[:street_number].empty?
    address_of_landlord = Address.where(
      street_number: params[:street_number], 
      street_name: params[:street_name].split.map(&:capitalize).join(' '), 
      city: params[:city].split.map(&:capitalize).join(' ')
    )
    address_of_landlord.each do |address|
      address.landlords.each do |landlord|
        @search_results << landlord
      end
    end
    erb :'landlords/index'
  # else

  end
end

get '/landlords/browse' do
  @search_results = Landlord.paginate(:page => params[:page], :per_page => 5)
  erb :'landlords/browse'
end

# Show form to create new landlord profile
get '/landlords/new' do
  if current_user
    erb :'/landlords/new'
  else
    erb :'/session/new'
  end
end

# Show landlord profile page
get '/landlords/:id' do
  @landlord = Landlord.find(params[:id])
  erb :'landlords/show'
end

# Create new landlord and redirect user to landlord profiles
post '/landlords/' do
  if current_user
  	check_landlord = Landlord.where(full_name: params[:full_name])
  	check_address = Address.where(unit_number: params[:unit_number], 
      street_number: params[:street_number], 
      street_name: params[:street_name], 
      city: params[:city])

  	match = []
  	check_landlord.each do |landlord|
  		check_address.each do |address|
  			match << (address.landlords.include? landlord)
  		end 
  	end

  	if !match.include? true

	    @landlord = Landlord.create(
	      user: current_user, 
	      full_name: params[:full_name]
	    )
	    @address = Address.create(
	      unit_number: params[:unit_number], 
	      street_number: params[:street_number], 
	      street_name: params[:street_name], 
	      city: params[:city]
	    )
	    Rental.create(
	      landlord: @landlord, 
	      address: @address
	    )
	    @rating = Rating.new(
	      user: @current_user, 
	      landlord: @landlord, 
	      communication: params[:communication], 
	      helpfulness: params[:helpfulness], 
	      reliability: params[:reliability], 
	      friendly: params[:friendly], 
	      comment: params[:comment]
	    )
	    if @rating.save
	    	redirect "/landlords/#{@landlord.id}"
	    else
				set_error("Your comment was too long! Try again!")
	      erb :'/landlords/new'
	    end
	  else
	  	set_error("Landlord and address already exists.")
	  	redirect "/landlords/#{check_landlord.first.id}"
	  end

  else
    erb :'/session/new'
  end
end

# Show form to create new rating
get '/landlords/:id/ratings/new' do
  if current_user
    @landlord = Landlord.find(params[:id])
    @rating = Rating.new
    erb :'ratings/new'
  else
    erb :'/session/new'
  end
end

# Create new rating and redirect user to landlord profile
post '/landlords/:id/ratings' do
  if current_user
    @rating = Rating.new(
      landlord_id: params[:landlord_id],
      user_id: current_user,
      communication: params[:communication],
      helpfulness: params[:helpfulness],
      reliability: params[:reliability],
      friendly: params[:friendly],
      comment: params[:comment]
    )
    if @rating.save
      redirect "landlords/#{params[:landlord_id]}"
    else
    	set_error("Your comment was too long! Try again!")
      erb :'/ratings/new'
    end
  else
    erb :'/session/new'
  end
end

# Show form to create new address
get '/landlords/:id/addresses/new' do
  if current_user
    @landlord = Landlord.find(params[:id])
    erb :'addresses/new'
  else
    erb :'/session/new'
  end
end

# Create new address to a landlord and redirect user back to landlord profile
post '/landlords/:id/addresses' do
  if current_user
    @address = Address.create(
      unit_number: params[:unit_number], 
      street_number: params[:street_number], 
      street_name: params[:street_name], 
      city: params[:city]
    )
    Rental.create(
      landlord_id: params[:landlord_id], 
      address_id: @address[:id]
    )
    redirect "landlords/#{params[:landlord_id]}"
  else
    erb :'/session/new'
  end  
end