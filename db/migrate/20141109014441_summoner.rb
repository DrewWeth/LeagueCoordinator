class Summoner < ActiveRecord::Migration
  def change
    add_column :users, :summoner_name, :string
    add_column :teams, :competition_id, :integer
    add_column :users, :phone, :string

  end
end
