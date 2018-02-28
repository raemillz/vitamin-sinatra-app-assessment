class User < ActiveRecord::Base
  has_secure_password
  has_many :vitamin_packs

  def slug
    self.username.gsub(/\s/, '-').downcase
  end

  def self.find_by_slug(slug)
    self.all.find{|a| a.slug == slug}
  end
end
