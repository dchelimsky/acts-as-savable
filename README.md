# ActsAsSavable

acts-as-savable extends an ActiveRecord model so that it can read from one data
source (table or view) and save to another (table).

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

## Motivation

My team was managing an app that had evolved to where we had several models
that were each backed by two different tables: one managed by another app, and
our local table that decorated the "remote" data with additional fields
specific to our app. This was originally modeled with two ActiveRecord models
per domain model: a LocalThing and a RemoteThing, each with connections to
separate databases. When loading a LocalThing it would load it's RemoteThing
and and delegate RemoteThing-related messages to the RemoteThing.

This worked fine when dealing with individual objects, but we had a problem:
there were roughly 18k rows in both tables, and we needed to paginate an index
view with sorting based on criteria split between the tables. This meant we had
to load 36k ActiveRecord objects in memory in order to know which 50 to display
on a web page. Go ahead, finish drinking that shot. I'll still be here ...

To resolve this we copied the remote tables to our local database (updated
periodically) and added a ComposedThing ActiveRecord model that was backed by a
view joining the tables backing the LocalThing and RemoteThing classes. This
worked swimmingly for the index pages, but now we had three different
ActiveRecord subclasses for every domain concept (and there were several that
followed this pattern).

What is now acts-as-savable allowed us to reduce this to one ActiveRecord model
per concept. There are still two tables and a view, but we were able to read
from the view and save to the local table, and the "remote" table is read only
to this app.
