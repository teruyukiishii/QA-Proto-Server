class User < ActiveRecord::Base
  # Include default devise modules.
  devise  :rememberable, :omniauthable
  include DeviseTokenAuth::Concerns::User
  devise  :rememberable, :omniauthable
end
