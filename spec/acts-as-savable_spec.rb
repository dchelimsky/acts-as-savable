require 'spec_helper'

ActiveRecord::Base.connection.instance_eval do
  create_table :things do |t|
    t.string :name
  end

  create_table :thing_decorations do |t|
    t.integer :thing_id
    t.string  :decoration
  end

  execute <<-SQL
    create view view_backed_things as
    select
      thing_decorations.id,
      things.id thing_id,
      things.name,
      thing_decorations.decoration
    from things
    left outer join thing_decorations on thing_decorations.thing_id = things.id;
  SQL
end

class Thing           < ActiveRecord::Base; end
class ThingDecoration < ActiveRecord::Base; end
class ViewBackedThing < ActiveRecord::Base
  saves_to :thing_decorations, :thing_id, :decoration
end

describe Acts::As::Savable do
  shared_examples "examples" do |group_description|
    metadata[:example_group][:description] = group_description

    it "using save" do
      view_backed_thing = ViewBackedThing.first
      view_backed_thing.decoration = "curtain"
      view_backed_thing.save
      ViewBackedThing.first.decoration.should eq("curtain")
    end

    it "using save!" do
      view_backed_thing = ViewBackedThing.first
      view_backed_thing.decoration = "curtain"
      view_backed_thing.save!
      ViewBackedThing.first.decoration.should eq("curtain")
    end

    it "using update_attribute" do
      view_backed_thing = ViewBackedThing.first
      view_backed_thing.update_attribute(:decoration, "curtain")
      ViewBackedThing.first.decoration.should eq("curtain")
    end

    it "using update_attributes" do
      view_backed_thing = ViewBackedThing.first
      view_backed_thing.update_attributes(:decoration => "curtain")
      ViewBackedThing.first.decoration.should eq("curtain")
    end

    it "using update_attributes!" do
      view_backed_thing = ViewBackedThing.first
      view_backed_thing.update_attributes!(:decoration => "curtain")
      ViewBackedThing.first.decoration.should eq("curtain")
    end
  end

  include_examples "examples", "creates a new record" do
    before(:each) do
      Thing.create!(:name => "Something")
    end
  end

  include_examples "examples", "updates an existing record" do
    before(:each) do
      thing = Thing.create!(:name => "Something")
      ThingDecoration.create!(
        :thing_id => thing.id,
        :decoration => nil
      )
    end
  end
end
