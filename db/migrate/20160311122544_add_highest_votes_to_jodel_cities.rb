class AddHighestVotesToJodelCities < ActiveRecord::Migration
  def change
    add_column :jodel_cities, :highest_votes, :integer
  end
end
