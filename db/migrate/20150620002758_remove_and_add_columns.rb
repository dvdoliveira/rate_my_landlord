class RemoveAndAddColumns < ActiveRecord::Migration
  def change
  	remove_column :ratings, :average_communication, :float
  	remove_column :ratings, :average_reliability, :float
  	remove_column :ratings, :average_helpfulness, :float
  	add_column :landlords, :average_communication, :float
  	add_column :landlords, :average_reliability, :float
  	add_column :landlords, :average_helpfulness, :float
  end
end
