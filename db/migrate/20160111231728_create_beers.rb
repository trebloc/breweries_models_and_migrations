class CreateBeers < ActiveRecord::Migration
  def change
    create_table :beers do |t|
      t.string :name
      t.decimal :abv

      t.timestamps null: false
    end
  end
end
