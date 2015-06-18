class Landlord < ActiveRecord::Base

	has_many :ratings
	belongs_to :user
	has_many :addresses, through: :rentals

end