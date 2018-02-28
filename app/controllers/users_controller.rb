require 'rack-flash'

class UsersController < ApplicationController
  use Rack::Flash

  get '/signup' do
    if !session[:user_id]
      erb :'users/new'
    else
      redirect to '/vitamins'
    end
  end

  post '/signup' do
    if params[:username] == "" || params[:password] == ""
      redirect to '/signup'
    else
      @user = User.create(:username => params[:username], :password => params[:password])
      session[:user_id] = @user.id
      redirect '/packs/new'
    end
  end

  get '/login' do
    @user = User.find_by(username: params[:username])
    if params[:username] == "" || params[:password] == ""
      flash[:message] = "You have left one or more fields blank. Please try again."
      redirect '/login'
    elsif @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/packs'
    else
      flash[:message] = "You have entered an incorrect password/username. Please try again, or create an account."
      redirect '/login'
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/packs"
    else
      redirect to '/signup'
    end
  end

  get '/users/:slug' do
    if !logged_in?
      redirect '/signup'
    end

    @user = User.find_by_slug(params[:slug])
    if !@user.nil? && @user == current_user
      erb :'users/show'
    else
      redirect '/packs'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/'
    end
  end

end
