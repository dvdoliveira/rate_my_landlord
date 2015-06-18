class Rental < ActiveRecord::Base

	belongs_to :landlord
	belongs_to :address

end