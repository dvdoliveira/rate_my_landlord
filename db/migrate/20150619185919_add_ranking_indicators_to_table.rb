class AddRankingIndicatorsToTable < ActiveRecord::Migration
  def change
  	add_column :rankings, :average_communication, :float
  	add_column :rankings, :average_reliability, :float
  	add_column :rankings, :average_helpfulness, :float
  end
end
