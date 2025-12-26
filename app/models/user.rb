class User < ApplicationRecord
  has_secure_password
  
  has_many :voice_generations, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
