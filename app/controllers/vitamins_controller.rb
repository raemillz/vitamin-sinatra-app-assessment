require 'rack-flash'

class VitaminsController < ApplicationController
  use Rack::Flash

  get "/vitamins" do
    redirect_if_not_logged_in
    @vitamins = Vitamin.all
    erb :'vitamins/index'
  end

  get "/vitamins/new" do
    redirect_if_not_logged_in
    @error_message = params[:error]
    erb :'vitamins/new'
  end

  get "/vitamins/:id/edit" do
    redirect_if_not_logged_in
    @error_message = params[:error]
    @vitamin = Vitamin.find_by_id(params[:id])
    if @vitamin && @vitamin.vitamin_pack.user == current_user
      erb :'vitamins/edit'
    else
      flash[:message] = "You only have access to edit your owns vitamins."
      redirect to '/vitamins'
    end
  end

  patch "/vitamins/:id" do
    redirect_if_not_logged_in
    if params[:content] == ""
      redirect to "/vitamins/#{params[:id]}/edit"
    else
      @vitamin = Vitamin.find_by_id(params[:id])
      if @vitamin && @vitamin.user == current_user
        if @vitamin.update(content: params[:content])
          redirect to "/vitamins/#{@vitamin.id}"
        else
          redirect to "/vitamins/#{@vitamin.id}/edit"
        end
      else
        redirect to '/vitamins'
      end
    end
  end

  get "/vitamins/:id" do
    redirect_if_not_logged_in
    @vitamin = Vitamin.find_by_id(params[:id])
    erb :'vitamins/show'
  end

  post "/vitamins" do
    redirect_if_not_logged_in
    if params[:benefits] == "" && params[:name] == ""
      redirect to "/vitamins/new"
    else
      current_user.vitamin_packs.each do |pack|
        @vitamin = pack.vitamins.build(name: params[:name], benefits: params[:benefits])
      end
      if @vitamin.save
        redirect to "/vitamins/#{@vitamin.id}"
      else
        redirect to "/vitamins/new"
      end
    end
  end

  delete '/vitamins/:id/delete' do
    if logged_in?
      @vitamin = Vitamin.find_by_id(params[:id])
      if @vitamin && @vitamin.user == current_user
        @vitamin.delete
      else
        flash[:message] = "You only have access to delete your owns vitamins."
        redirect to '/vitamins'
      end
      redirect to '/vitamins'
    else
      redirect to '/login'
    end
  end

end
