class RemoveBrewerNameFromBeer < ActiveRecord::Migration
  def change
    remove_column :beers, :brewery_name, :string
  end
end
