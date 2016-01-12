class CreateBrewers < ActiveRecord::Migration
  def change
    create_table :brewers do |t|
      t.string :name
      t.string :city
      t.string :state
      t.string :website_url

      t.timestamps null: false
    end
  end
end
