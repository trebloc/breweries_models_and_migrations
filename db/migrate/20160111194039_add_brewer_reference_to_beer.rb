class AddBrewerReferenceToBeer < ActiveRecord::Migration
  def change
    add_reference :beers, :brewer, index: true, foreign_key: true
  end
end
