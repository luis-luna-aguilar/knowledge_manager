require 'spec_helper'

describe Tag do

  it { should have_and_belong_to_many(:articles) }
  it { should have_and_belong_to_many(:knowledge_pieces) }

  context "validations" do

    it "should have a name" do
      tag = Tag.create(name: nil)
      tag.should_not be_valid
    end

    it "shouldn't have an empty name" do
      tag = Tag.create(name: "")
      tag.should_not be_valid
    end

    it "should be a unique name between siblings on creation" do
      Tag.create(name: "root")
      tag = Tag.create(name: "root")
      tag.should_not be_valid

      TagBuilder.new("root:1st_lvl_1").create!
      tag = TagBuilder.new("root:1st_lvl_1").create!
      tag.should_not be_valid
    end

    it "should be a unique name between siblings on update" do
      root_1 = Tag.create(name: "root-1")
      root_2 = Tag.create(name: "root-2")

      root_1.name = "root-3"
      root_1.should be_valid

      root_1.name = "root-2"
      root_1.should_not be_valid
    end

  end

  it "should find descendants name from the name contained in any ancestor" do
    Tag.destroy_all
    
    Tag.create(name: "root")
    Tag.create(name: "rootlings")

    tag_1 = TagBuilder.new("root:child-1").create!
    tag_2 = TagBuilder.new("child-1:child-2").create!
    tag_3 = TagBuilder.new("rootlings:child-3").create!
    tag_4 = TagBuilder.new("child-3:child-4").create!
    expected_result = [tag_1, tag_2, tag_3, tag_4]

    Tag.find_descendants_by_ancestor_name("root").should == expected_result
  end

  it "should return the closest unique ancestor" do
    Tag.destroy_all
    
    Tag.create(name: "root")
    TagBuilder.new("root:1st_lvl_1").create!
    TagBuilder.new("root:1st_lvl_2").create!

    TagBuilder.new("1st_lvl_1:2nd_lvl_1").create!
    TagBuilder.new("1st_lvl_2:2nd_lvl_1").create!

    tag = TagBuilder.new("1st_lvl_2:2nd_lvl_1:test_tag").create!
    tag.closest_unique_ancestor.name.should == "1st_lvl_2"
  end

  context "tag unique name" do

    before do
      Tag.destroy_all
    end

    it "should create a root tag with a 1 level name" do
      tag = Tag.create(name: "root")
      tag.unique_name.should == "root"
    end

    it "should create a child tag with a 2 levels name, if given parent is unique" do
      Tag.create(name: "root")
      TagBuilder.new("root:1st_lvl_1").create!
      tag = TagBuilder.new("1st_lvl_1:2nd_lvl_1").create!

      tag.unique_name.should == "1st_lvl_1:2nd_lvl_1"
      tag.parent.name.should == "1st_lvl_1"
      tag.parent.parent.name.should == "root"
    end

    it "should create a grandchild tag with a 3 levels name, if given parent is not unique" do
      Tag.create(name: "root")
      TagBuilder.new("root:1st_lvl_1").create!
      TagBuilder.new("root:1st_lvl_2").create!

      TagBuilder.new("1st_lvl_1:2nd_lvl_1").create!
      TagBuilder.new("1st_lvl_2:2nd_lvl_1").create!

      tag = TagBuilder.new("1st_lvl_2:2nd_lvl_1:test_tag").create!
      tag.unique_name.should == "1st_lvl_2:2nd_lvl_1:test_tag"
      tag.parent.name.should == "2nd_lvl_1"
      tag.parent.parent.name.should == "1st_lvl_2"
      tag.parent.parent.parent.name.should == "root"
    end

    it "should find a tag by it's unique name" do
      Tag.create(name: "root")
      Tag.create(name: "root-1")
      TagBuilder.new("root-1:1st_lvl_1").create!
      tag = TagBuilder.new("root:1st_lvl_1").create!

      Tag.find_by_unique_name("root:1st_lvl_1").should == tag
    end

  end

end