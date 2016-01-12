class AddYearFoundedToBrewer < ActiveRecord::Migration
  def change
    add_column :brewers, :year_founded, :string
  end
end
