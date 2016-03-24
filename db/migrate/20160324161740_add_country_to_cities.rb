class AddCountryToCities < ActiveRecord::Migration
  def change
    add_column :jodel_cities, :country, :string, default: "DE"
  end
end
