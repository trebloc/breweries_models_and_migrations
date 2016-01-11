class AddDescriptionsToBeers < ActiveRecord::Migration
  def change
    add_column :beers, :brewery_name, :string
    add_column :beers, :short_description, :string
    add_column :beers, :long_description, :text
    add_column :beers, :style, :string
  end
end
