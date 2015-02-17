class CompLoc < ActiveRecord::Migration
  def change
    add_column :competitions, :location, :string
  end
end
