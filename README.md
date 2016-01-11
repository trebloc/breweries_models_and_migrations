# Active Record Migrations and Associations Lab - Backend Breweries

We're going to build a beer app.  

More specifically we want to keep track of the beers brewed by various brewing companies.  We'll be skipping the front-end code and focusing solely on things tied to the database.  
This lab will force you to write and run several migrations so you get experience doing so.  

| Objectives |
| :--- |
| Add columns to the database using database migrations |
| Remove columns from the database using migrations |
| Create associations between two models |
| Write a migration to add foreign keys to tables |

## Introduction

Our system is going to track two types of data.

1. breweries
2. beers (varieties of beers)

This means we'll have two models and a relationship between them.  We'll determine specific column names as we move forward.

### Committing
Every time you make a change that is atomic, commit your changes.  We should be able to see **at least 1 commit for each step in the lab**.

## Step 1 - The first model

The first model we'll create is the beer model.  Use the `rails g model` command to create a new model `beer` and migration with columns:
* name
* abv

Determine appropriate data-types for these columns.  

<details><summary>spoiler</summary>
`> rails g model beer name:string abv:decimal`

```ruby
# db/migrate/20160111190152_create_beers.rb
class CreateBeers < ActiveRecord::Migration
  def change
    create_table :beers do |t|
      t.string :name
      t.decimal :abv

      t.timestamps null: false
    end
  end
end
```
```ruby
# app/models/beer.rb
class Beer < ActiveRecord::Base
end
```
</details>

Verify your changes and then run `rake db:create db:migrate`.
> Note that you can chain rake commands on one-line.

As always commit your changes.  (It should be 3 files.)  For all steps, feel free to commit **after testing** your change.

### Test your changes in the console

Run `rails c` or `rails console`

In the console play around and save a few beers (at least 3).  Use commands like:

* `Beer.all`
* `Beer.new`
* `Beer.create`
* `Beer.destroy_all`
* `Beer.find`
* `Beer.find_by_xxxxxx`
* `#save`

Example:
```console
Running via Spring preloader in process 7845
Loading development environment (Rails 4.2.4)
irb(main):001:0> Beer.all
  Beer Load (0.3ms)  SELECT "beers".* FROM "beers"
=> #<ActiveRecord::Relation []>
irb(main):002:0> od = Beer.new(name: "Original Dankster", abv: 8.2)
=> #<Beer id: nil, name: "Original Dankster", abv: #<BigDecimal:7fa82d9a6b90,'0.82E1',18(36)>, created_at: nil, updated_at: nil>
irb(main):003:0> od.save
   (0.2ms)  BEGIN
  SQL (0.3ms)  INSERT INTO "beers" ("name", "abv", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["name", "Original Dankster"], ["abv", "8.2"], ["created_at", "2016-01-11 19:12:29.282974"], ["updated_at", "2016-01-11 19:12:29.282974"]]
   (1.0ms)  COMMIT
=> true
irb(main):004:0> Beer.all
  Beer Load (0.4ms)  SELECT "beers".* FROM "beers"
=> #<ActiveRecord::Relation [#<Beer id: 2, name: "Original Dankster", abv: #<BigDecimal:7fa82d974f28,'0.82E1',18(18)>, created_at: "2016-01-11 19:12:29", updated_at: "2016-01-11 19:12:29">]>
irb(main):005:0> mo = Beer.create(name: "Mo' Simcoe", abv: 6.5)
   (0.2ms)  BEGIN
  SQL (0.3ms)  INSERT INTO "beers" ("name", "abv", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["name", "Mo' Simcoe"], ["abv", "6.5"], ["created_at", "2016-01-11 19:13:35.464834"], ["updated_at", "2016-01-11 19:13:35.464834"]]
   (1.0ms)  COMMIT
=> #<Beer id: 3, name: "Mo' Simcoe", abv: #<BigDecimal:7fa82d95e020,'0.65E1',18(36)>, created_at: "2016-01-11 19:13:35", updated_at: "2016-01-11 19:13:35">
irb(main):006:0> Beer.create(name: "Bangerang", abv: 6.5)
   (0.2ms)  BEGIN
  SQL (0.2ms)  INSERT INTO "beers" ("name", "abv", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["name", "Bangerang"], ["abv", "6.5"], ["created_at", "2016-01-11 19:14:44.839058"], ["updated_at", "2016-01-11 19:14:44.839058"]]
   (1.0ms)  COMMIT
=> #<Beer id: 4, name: "Bangerang", abv: #<BigDecimal:7fa82f113148,'0.65E1',18(36)>, created_at: "2016-01-11 19:14:44", updated_at: "2016-01-11 19:14:44">
irb(main):007:0> Beer.all.count
   (0.5ms)  SELECT COUNT(*) FROM "beers"
=> 3
```


## Step 2 - Adding more columns

Obviously a beer is more than just it's abv and name.  Let's track more information.

Write and run a migration to add fields for:

* brewery_name
* short_description (less than 255 chars)
* long_description
* style  (e.g. IPA, Porter)

<details><summary>spoiler</summary>
`rails g migration AddDescriptionsToBeers brewery_name:string short_description:string long_description:text style:string`

```rb
class AddDescriptionsToBeers < ActiveRecord::Migration
  def change
    add_column :beers, :brewery_name, :string
    add_column :beers, :short_description, :string
    add_column :beers, :long_description, :text
    add_column :beers, :style, :string
  end
end
```
</details>

* After creating the migration, what do you need to run?
* What files are changed?  Should you commit them?

### Test your changes in the console

1. Add a couple new beers and fill in some of the new fields
1. Find and update your previously created beers, add more details.


<details><summary>sample</summary>
```console
=> #<ActiveRecord::Relation [#<Beer id: 3, name: "Mo' Simcoe", abv: #<BigDecimal:7fa82c26f0d0,'0.65E1',18(18)>, created_at: "2016-01-11 19:13:35", updated_at: "2016-01-11 19:13:35", brewery_name: nil, short_description: nil, long_desc
```
</details>


## Step 3 - Create the Second Model

Our Second model will be to track brewing companies; let's call it `Brewer`.

What sort of data would we want to track about brewers?
A few possibilities:
* name
* city
* state
* website_url

Feel free to add your own!

Go ahead and make these database changes now.  

### Test your changes in the console

Enter the rails console and add a couple of brewers.  We don't yet have any association with the beers themselves, don't worry about that, we're coming to it soon.  For now just create a couple brewers.

<details><summary>sample</summary>
```
irb(main):002:0> Brewer.create(name: "Cellarmaker Brewing Co.", city: "San Francisco", state: "CA")
   (0.1ms)  BEGIN
  SQL (0.4ms)  INSERT INTO "brewers" ("name", "city", "state", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5) RETURNING "id"  [["name", "Cellarmaker Brewing Co."], ["city", "San Francisco"], ["state", "CA"], ["created_at", "2016-01-11 19:32:42.792078"], ["updated_at", "2016-01-11 19:32:42.792078"]]
   (0.4ms)  COMMIT
=> #<Brewer id: 1, name: "Cellarmaker Brewing Co.", state: "CA", city: "San Francisco", website_url: nil, created_at: "2016-01-11 19:32:42", updated_at: "2016-01-11 19:32:42">
irb(main):003:0> Brewer.last
  Brewer Load (0.7ms)  SELECT  "brewers".* FROM "brewers"  ORDER BY "brewers"."id" DESC LIMIT 1
=> #<Brewer id: 1, name: "Cellarmaker Brewing Co.", state: "CA", city: "San Francisco", website_url: nil, created_at: "2016-01-11 19:32:42", updated_at: "2016-01-11 19:32:42">
```
</details>


## Step 4 - 1:N

As you can imagine most brewers produce more than one variety of beer.  Also we know that each beer can only be associated with one brewer.  

That means we have a 1:N relationship.

***Quick quiz***

Please complete the following using ActiveRecord terminology.

| Fill in the blank |
| :--- |
| A brewer __________ beers. |
| A beer _________ a brewer. |

* Which table will contain the **foreign key**?

<details><summary>solution</summary>
|
 A brewer **has_many** beers. |
| A beer **belongs_to** a brewer. |

* The beers table will contain a foreign key to tie it to each brewer.
</details>

---


Do the following:

1. Write and run a migration to add the foreign_key
 * Don't forget about using `references` or `belongs_to`
1. Update the rails model files to specify the relationship between beer and brewer.

<details><summary>spoiler</summary>

`rails g migration AddBrewerReferenceToBeer brewer:references`

Isn't this nice:
```ruby
class AddBrewerReferenceToBeer < ActiveRecord::Migration
  def change
    add_reference :beers, :brewer, index: true, foreign_key: true
  end
end
```

</details>

> did you commit?  The migration, schema.rb and the two models should all be in one commit.  They require each other to continue working.

### Test your change in the console

You might start with something easy like: `Brewer.last.beers << Beer.last`


```
irb(main):001:0> Brewer.last
  Brewer Load (0.6ms)  SELECT  "brewers".* FROM "brewers"  ORDER BY "brewers"."id" DESC LIMIT 1
=> #<Brewer id: 1, name: "Cellarmaker Brewing Co.", state: "CA", city: "San Francisco", website_url: nil, created_at: "2016-01-11 19:32:42", updated_at: "2016-01-11 19:32:42">
irb(main):002:0> Brewer.last.beers << Beer.last
  Brewer Load (0.5ms)  SELECT  "brewers".* FROM "brewers"  ORDER BY "brewers"."id" DESC LIMIT 1
  Beer Load (0.4ms)  SELECT  "beers".* FROM "beers"  ORDER BY "beers"."id" DESC LIMIT 1
   (0.1ms)  BEGIN
  SQL (0.5ms)  UPDATE "beers" SET "brewer_id" = $1, "updated_at" = $2 WHERE "beers"."id" = $3  [["brewer_id", 1], ["updated_at", "2016-01-11 19:43:26.433293"], ["id", 4]]
   (6.0ms)  COMMIT
  Beer Load (0.2ms)  SELECT "beers".* FROM "beers" WHERE "beers"."brewer_id" = $1  [["brewer_id", 1]]
=> #<ActiveRecord::Associations::CollectionProxy [#<Beer id: 4, name: "Bangerang", abv: #<BigDecimal:7fa82d9c48e8,'0.65E1',18(18)>, created_at: "2016-01-11 19:14:44", updated_at: "2016-01-11 19:43:26", brewery_name: nil, short_description: nil, long_description: nil, style: nil, brewer_id: 1>]>
irb(main):003:0> Brewer.last
  Brewer Load (0.4ms)  SELECT  "brewers".* FROM "brewers"  ORDER BY "brewers"."id" DESC LIMIT 1
=> #<Brewer id: 1, name: "Cellarmaker Brewing Co.", state: "CA", city: "San Francisco", website_url: nil, created_at: "2016-01-11 19:32:42", updated_at: "2016-01-11 19:32:42">
irb(main):004:0> Brewer.last.beers
  Brewer Load (0.5ms)  SELECT  "brewers".* FROM "brewers"  ORDER BY "brewers"."id" DESC LIMIT 1
  Beer Load (0.3ms)  SELECT "beers".* FROM "beers" WHERE "beers"."brewer_id" = $1  [["brewer_id", 1]]
=> #<ActiveRecord::Associations::CollectionProxy [#<Beer id: 4, name: "Bangerang", abv: #<BigDecimal:7fa82f1667f8,'0.65E1',18(18)>, created_at: "2016-01-11 19:14:44", updated_at: "2016-01-11 19:43:26", brewery_name: nil, short_description: nil, long_description: nil, style: nil, brewer_id: 1>]>
irb(main):005:0> Brewer.last.beers.count
  Brewer Load (0.5ms)  SELECT  "brewers".* FROM "brewers"  ORDER BY "brewers"."id" DESC LIMIT 1
   (0.2ms)  SELECT COUNT(*) FROM "beers" WHERE "beers"."brewer_id" = $1  [["brewer_id", 1]]
=> 1
```

## Step 5 - remove the brewery_name column

Since we now have a separate model for the brewer we no longer need a column on the beers table to list the brewery_name.

1. Write and run a migration to remove the unneeded column.
1. Verify your changes in the console.  

<details><summary>spoiler</summary>
`rails g migration RemoveBrewerNameFromBeer brewery_name:string`
</details>

## More

On your own do the following:

1. Add more columns to `Brewer` like `year_founded`, `phone`, `latitude`, `longitude`, `image_url`
1. Add more columns to `Beer` like `ibu` (international bittering unit), `seasonal` (true/false) etc
1. Create a new model Review to track reviews for each Beer.
  * Associate this table with the Beer table.
  * Add a few fake reviews.

## Advanced Challenges
1. Delete this app and start over; re-build it from scratch.
1. Create controllers and at least one view to show the above data.
