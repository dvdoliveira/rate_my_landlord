class User < ActiveRecord::Base
  attr_accessor :password
  before_save :encrypt_password

	has_many :landlords
	has_many :ratings

	validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/ }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password, confirmation: true
  validate :compare_passwords


  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def compare_passwords
    if password != password_confirmation
      errors.add(:base, "Passwords don't match. Please verify and try again.")
    end
  end
end