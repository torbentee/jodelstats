class CreateJodelCities < ActiveRecord::Migration
  def change
    create_table :jodel_cities do |t|
      t.string :name
      t.string :loudest_jodel
      t.string :latitude
      t.string :longitude

      t.timestamps null: false
    end

    add_index :jodel_cities, :name, :unique => true
  end
end
