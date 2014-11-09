class CreatePlayersInCompetitions < ActiveRecord::Migration
  def change
    create_table :players_in_competitions do |t|
      t.integer :competition_id
      t.integer :user_id
      t.integer :team_id, :default => nil

      t.timestamps
    end
  end
end
