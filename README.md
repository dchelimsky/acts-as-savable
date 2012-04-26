# ActsAsSavable

acts-as-savable extends an ActiveRecord model so that it can read from one
source and save to another.

## Installation

Add this line to your application's Gemfile:

    gem 'acts-as-savable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acts-as-savable

## Usage

Given tables named "things" and "thing_decorations", and a view named
"decorated_things" that joins on the other two, you can declare a
`DecoratedThing` class like this:

    class DecoratedThing < ActiveRecord::Base
      saves_to :thing_decorations, :thing_id, :decoration
    end

All the finders work as expected, but `save`, `save!`, `update_attribute`,
`update_attributes`, and `update_attributes!` all create and/or update records
in the "thing_decorations" table (in this example updating ony the `:thing_id`
and `:decoration` columns).

## Status

This was extracted from an app, and is constrained by assumptions related to
that app. It is very naive and not likely to solve all, if any, of your
problems. If you have a problem that this almost solves, but not quite, please
file an issue at https://github.com/dchelimsky/acts-as-savable/issues and help
me to make it useful for more scenarios.
