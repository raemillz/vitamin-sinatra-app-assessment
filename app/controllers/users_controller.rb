require 'rack-flash'

class UsersController < ApplicationController
  use Rack::Flash

  get '/signup' do
    if !session[:user_id]
      erb :'users/new'
    else
      redirect to '/packs/new'
    end
  end

  post '/signup' do
    if params[:username] == "" || params[:password] == ""
      flash[:message] = "You have left one or more fields blank!"
      redirect '/signup'
    elsif User.find_by(:username => params[:username])
      flash[:message] = "That username is already in use. Please try again."
      redirect '/signup'
    else
      @user = User.create(:username => params[:username], :password => params[:password])
      session[:user_id] = @user.id
      flash[:message] = "Thank you for signing up for Vitamin Tracker!"
      redirect '/login'
    end
  end

  get '/login' do
    if !session[:user_id]
      erb :'users/new'
    else
      redirect to '/packs'
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
