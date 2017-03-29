class User < ActiveRecord::Base
  extend Devise::Models
  devise :database_authenticatable, :validatable, :registerable, stretches: 12
  include DeviseTokenAuth::Concerns::User
end
