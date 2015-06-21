class LandlordCreatedAt < ActiveRecord::Migration
  def change
    add_column :landlords, :created_at, :datetime
    add_column :landlords, :updated_at, :datetime
  end
end
