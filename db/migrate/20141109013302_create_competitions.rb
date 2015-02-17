class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.string :name
      t.text :description
      t.datetime :at
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
