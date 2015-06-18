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
  erb :'landlords/index'
end

get '/landlords/:id' do
  erb :'landlords/show'
end







