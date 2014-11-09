class Active < ActiveRecord::Migration
  def change
    change_column :teams, :active, :boolean, :default => true
    change_column :competitions, :active, :boolean, :default => true

  end
end
