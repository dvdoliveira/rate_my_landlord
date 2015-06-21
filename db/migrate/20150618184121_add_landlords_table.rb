class AddLandlordsTable < ActiveRecord::Migration
  def change
  	create_table :landlords do |t|
  		t.integer :user_id, index: true
  		t.string :full_name
  		t.float :average_rating
  		t.boolean :friendly, default: false
  	end
  end
end
