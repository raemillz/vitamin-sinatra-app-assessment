class VitaminPack < ActiveRecord::Base
  has_many :vitamins
  belongs_to :user

  def self.valid_params?(params)
    return !params[:name].empty? 
  end
end
