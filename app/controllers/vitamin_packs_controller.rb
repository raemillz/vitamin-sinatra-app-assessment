require 'rack-flash'

class VitaminPacksController < ApplicationController
  use Rack::Flash

  get "/packs" do
    redirect_if_not_logged_in
    @packs = VitaminPack.all
    erb :'vitamin_packs/index'
  end

  get "/packs/new" do
    redirect_if_not_logged_in
    @error_message = params[:error]
    erb :'vitamin_packs/new'
  end

  get "/packs/:id/edit" do
    redirect_if_not_logged_in
    @error_message = params[:error]
    @pack = VitaminPack.find_by_id(params[:id])
      if @pack && @pack.user == current_user
        erb :'vitamin_packs/edit'
      else
        flash[:message] = "You only have access to edit your owns packs."
        redirect to '/packs'
      end
  end

  patch "/packs/:id" do
    redirect_if_not_logged_in
    if params[:name] == ""
      redirect to "/packs/#{params[:id]}/edit"
    else
      @pack = VitaminPack.find_by_id(params[:id])
      if @pack && @pack.user == current_user
        if @pack.update(name: params[:name])
          redirect to "/packs/#{@pack.id}"
        else
          redirect to "/packs/#{@pack.id}/edit"
        end
      else
        redirect to '/packs'
      end
    end
  end

  get "/packs/:id" do
    redirect_if_not_logged_in
    @pack = VitaminPack.find_by_id(params[:id])
    erb :'vitamin_packs/show'
  end

  post "/packs" do
    redirect_if_not_logged_in
    if params[:content] == ""
      redirect to "/packs/new"
    else
      @pack = current_user.vitamin_packs.build(name: params[:name])
      if @pack.save
        redirect to "/packs/#{@pack.id}"
      else
        redirect to "/packs/new"
      end
    end
  end

  delete '/packs/:id/delete' do
    if logged_in?
      @pack = VitaminPack.find_by_id(params[:id])
      if @pack && @pack.user == current_user
        @pack.delete
      else
        flash[:message] = "You only have access to edit your owns packs."
        redirect to '/packs'
      end
      redirect to '/packs'
    else
      redirect to '/login'
    end
  end

end
