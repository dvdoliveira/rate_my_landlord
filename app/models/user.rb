class User < ActiveRecord::Base
  attr_accessor :password
  before_save :encrypt_password

	has_many :landlords
	has_many :ratings

	validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates_confirmation_of :password, message: 'should match confirmation'


  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end