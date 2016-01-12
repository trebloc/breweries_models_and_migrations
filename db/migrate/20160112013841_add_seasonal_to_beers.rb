class AddSeasonalToBeers < ActiveRecord::Migration
  def change
    add_column :beers, :seasonal, :boolean
  end
end
