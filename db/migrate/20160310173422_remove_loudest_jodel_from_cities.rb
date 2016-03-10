class RemoveLoudestJodelFromCities < ActiveRecord::Migration
  def change
    remove_column :jodel_cities, :loudest_jodel
    remove_column :jodel_cities, :loudest_votes
  end
end
