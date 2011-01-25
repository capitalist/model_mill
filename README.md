# Model Mill #

## What it Does

This bad boy will crank out models based on tables in an existing database.

If you provide the namespace option, it will generate models in that namespace that inherit from a common base class. What's more, that base class will get it's connection information from the namespace name in database.yml. This means you can connect to both database at once to migrate data from one to the other.

## Usage

1. Add `gem "model_mill"` to your Gemfile
2. `bundle install`
3. `rails generate model_mill:models --namespace=whatever`

This will generate models from each table in the specified namespace. Each model will contain an `attr_accessible` for every attribute. Be sure to delete the ones that you do not need.

## Contributing to model_mill
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Joe Martinez. See LICENSE.txt for
further details.

