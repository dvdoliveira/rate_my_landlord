class Landlord < ActiveRecord::Base

	has_many :ratings
	belongs_to :user
	has_many :rentals
	has_many :addresses, through: :rentals

	validates :full_name, presence: true

end