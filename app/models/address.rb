class Address < ActiveRecord::Base

	has_many :landlords, through: :rentals

end