class VitaminPacksController < ApplicationController
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
    @pack = VitaminPack.find(params[:id])
    erb :'vitamin_packs/edit'
  end

  post "/packs/:id" do
    redirect_if_not_logged_in
    @pack = VitaminPack.find(params[:id])
    unless VitaminPack.valid_params?(params)
      redirect "/packs/#{@pack.id}/edit?error=invalid vitamin pack"
    end
    @pack.update(params.select{|k|k=="name" || k=="capacity"})
    redirect "/packs/#{@pack.id}"
  end

  get "/packs/:id" do
    redirect_if_not_logged_in
    @pack = VitaminPack.find(params[:id])
    erb :'vitamin_packs/show'
  end

  post "/packs" do
    redirect_if_not_logged_in

    unless VitaminPack.valid_params?(params)
      redirect "/packs/new?error=invalid vitamin pack"
    end
    VitaminPack.create(params)
    redirect "/packs"
  end

end
