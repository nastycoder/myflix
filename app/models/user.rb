class User < ActiveRecord::Base
  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  # Turned secure password validations off to stop the complaining about password_confirmation
  has_secure_password validations: false
end