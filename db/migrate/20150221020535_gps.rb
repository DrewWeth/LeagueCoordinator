class Gps < ActiveRecord::Migration
  def change
    add_column :competitions, :latitude, :float
    add_column :competitions, :longitude, :float
  end
end
