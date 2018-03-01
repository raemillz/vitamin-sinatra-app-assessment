require 'rack-flash'

class UsersController < ApplicationController
  use Rack::Flash

  get '/signup' do
    if logged_in?
      redirect to '/packs'
    else
      erb :'users/new'
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
    if !logged_in?
      erb :'/'
    else
      redirect to '/packs'
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if params[:username] == "" || params[:password] == ""
      flash[:message] = "You have left one or more fields blank. Please try again."
      redirect '/login'
    elsif @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/packs'
    else
      flash[:message] = "You have entered an incorrect password/username. Please try again, or create an account."
      redirect to '/'
    end
  end

  get '/users/:slug' do
    if logged_in?
      @user = User.find_by_slug(params[:slug])
      @packs = @user.packs
      @packs.order! 'created_at DESC'
      erb :'/users/show'
    else
      redirect '/'
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
