class AddLoudestVotesToJodelCities < ActiveRecord::Migration
  def change
    add_column :jodel_cities, :loudest_votes, :integer
  end
end
