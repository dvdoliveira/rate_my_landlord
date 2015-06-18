class AddAddressesTable < ActiveRecord::Migration
  def change
  	create_table :addresses do |t|
  		t.integer :unit_number
  		t.integer :street_number
  		t.string :street_name
  		t.string :city
  	end
  end
end
