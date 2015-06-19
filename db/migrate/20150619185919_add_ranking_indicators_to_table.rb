class AddRankingIndicatorsToTable < ActiveRecord::Migration
  def change
<<<<<<< HEAD
  	add_column :ratings, :average_communication, :float
  	add_column :ratings, :average_reliability, :float
  	add_column :ratings, :average_helpfulness, :float
=======
  	add_column :rankings, :average_communication, :float
  	add_column :rankings, :average_reliability, :float
  	add_column :rankings, :average_helpfulness, :float
>>>>>>> master
  end
end
