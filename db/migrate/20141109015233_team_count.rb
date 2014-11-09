class TeamCount < ActiveRecord::Migration
  def change
      add_column :teams, :count, :integer, :default => 0
  end
end
