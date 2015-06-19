class AddRankingIndicatorsToTable < ActiveRecord::Migration
  def change
  	add_column :ratings, :average_communication, :float
  	add_column :ratings, :average_reliability, :float
  	add_column :ratings, :average_helpfulness, :float
  end
end
