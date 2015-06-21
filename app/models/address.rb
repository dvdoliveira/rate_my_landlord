class Address < ActiveRecord::Base

	has_many :rentals
	has_many :landlords, through: :rentals

end