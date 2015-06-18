class User < ActiveRecord::Base

	has_many :landlords
	has_many :ratings

	validates :email, uniqueness: true, presence: true
	validates :password, presence: true, length: { minimum: 6 }

end