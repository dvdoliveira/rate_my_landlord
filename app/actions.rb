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
  erb :'users/new'
end

# Sign-up and redirects users to homepage
post '/users' do
  redirect '/'
end

# Logout action and redirects logged out users to homepage
delete '/session' do
  redirect '/'
end

# Index of landlords
get '/landlords' do
  if params[:name]
    @search_results = Landlord.where(full_name: params[:name])
    # binding.pry
    @search_results.length == 1 ? (redirect "/landlords/#{@search_results.first.id}") : (erb :'landlords/index')
  else
    @search_results = []
    address_of_landlord = Address.where(street_number: params[:street_number], street_name: params[:street_name], city: params[:city])

    address_of_landlord.each do |address|
      address.landlords.each do |landlord|
        @search_results << landlord
      end
    end

    erb :'landlords/index'

  end
end

# Show landlord profile page
get '/landlords/:id' do
  @landlord = Landlord.find(params[:id])
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



