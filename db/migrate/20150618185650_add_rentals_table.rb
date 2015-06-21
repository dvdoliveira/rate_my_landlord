class AddRentalsTable < ActiveRecord::Migration
  def change
  	create_table :rentals do |t|
  		t.integer :landlord_id, index: true
  		t.integer :address_id, index: true
  	end
  end
end
