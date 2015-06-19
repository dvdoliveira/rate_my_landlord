class Rating < ActiveRecord::Base

	belongs_to :user
	belongs_to :landlord

	validates :communication, presence: true, numericality: { minimum: 1, maximum: 5 }
	validates :helpfulness, presence: true, numericality: { minimum: 1, maximum: 5 }
	validates :reliability, presence: true, numericality: { minimum: 1, maximum: 5 }
	validates :comment, length: { maximum: 800 }

	after_save :update_landlord_average_rating
	after_create :update_friendly_icon

	private

	def update_landlord_average_rating
		all_landlord_ratings = Rating.where(landlord_id: landlord_id)
		num_landlord_ratings = all_landlord_ratings.length
		landlord.average_communication = all_landlord_ratings.sum(:communication).to_f / num_landlord_ratings
		landlord.average_helpfulness = all_landlord_ratings.sum(:helpfulness).to_f / num_landlord_ratings
		landlord.average_reliability = all_landlord_ratings.sum(:reliability).to_f / num_landlord_ratings
		average_rating = (landlord.average_communication + landlord.average_helpfulness + landlord.average_reliability) / 3
		landlord.average_rating = (average_rating * 2).round / 2.0
		landlord.save
	end

	def update_friendly_icon
		if !landlord.friendly && Rating.where(landlord_id: landlord_id).where(friendly: true).count(:friendly) >= 2
			landlord.friendly = true
			landlord.save
		end
	end

end