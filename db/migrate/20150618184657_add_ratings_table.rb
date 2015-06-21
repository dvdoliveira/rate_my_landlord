class AddRatingsTable < ActiveRecord::Migration
  def change
  	create_table :ratings do |t|
      t.integer :user_id, index: true
      t.integer :landlord_id, index: true
  		t.integer :communication
  		t.integer :helpfulness
  		t.integer :reliability
  		t.boolean :friendly
  		t.string :comment
  		t.timestamps
  	end
  end
end
