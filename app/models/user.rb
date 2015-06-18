class User < ActiveRecord::Base

	has_many :landlords
	has_many :ratings

end