class Vitamin < ActiveRecord::Base
  belongs_to :vitamin_pack

  def self.valid_params?(params)
    return !params[:name].empty? && !params[:benefits].empty?
  end
end
