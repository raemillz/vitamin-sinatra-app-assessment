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
    @vitamin = Vitamin.find(params[:id])
    erb :'vitamins/edit'
  end

  post "/vitamins/:id" do
    redirect_if_not_logged_in
    @vitamin = Vitamin.find(params[:id])
    unless Vitamin.valid_params?(params)
      redirect "/vitamins/#{@vitamin.id}/edit?error=invalid vitamin"
    end
    @vitamin.update(params.select{|k|k=="name" || k=="benefit" || k=="vitamin_pack_id"})
    redirect "/vitamins/#{@vitamin.id}"
  end

  get "/vitamins/:id" do
    redirect_if_not_logged_in
    @vitamin = Vitamin.find(params[:id])
    erb :'vitamins/show'
  end

  post "/vitamins" do
    redirect_if_not_logged_in
    unless Vitamin.valid_params?(params)
      redirect "/vitamins/new?error=invalid vitamin"
    end
    Vitamin.create(params)
    redirect "/vitamins"
  end
end
