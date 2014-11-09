class Owners < ActiveRecord::Migration
  def change
    add_column :teams, :user_id, :integer
    add_column :competitions, :user_id, :integer

  end
end
