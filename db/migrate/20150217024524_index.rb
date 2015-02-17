class Index < ActiveRecord::Migration
  def change
    add_index :competitions, :user_id

    add_index :teams, :competition_id
    add_index :teams, :user_id

    add_index :players_in_competitions, :user_id
    add_index :players_in_competitions, :competition_id
    add_index :players_in_competitions, :team_id
  end
end
