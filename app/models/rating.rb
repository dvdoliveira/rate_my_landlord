class Rating < ActiveRecord::Base

	belongs_to :user
	belongs_to :landlord

	validates :communication, numericality: { minimum: 1, maximum: 5 }
	validates :helpfulness, numericality: { minimum: 1, maximum: 5 }
	validates :reliability, numericality: { minimum: 1, maximum: 5 }
	validates :comment, length: { maximum: 800 }

end