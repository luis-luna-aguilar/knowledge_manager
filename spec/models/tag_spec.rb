require 'spec_helper'

describe Tag do

  context "validations" do

    it "should have a name" do
      expect { Tag.create(name: nil) }.to raise_error
    end

    it "should not have an empty name" do
      expect { Tag.create(name: "") }.to raise_error
    end

    it "should validate the name structure on creation, so that it don't have empty parts" do
      expect { Tag.create(name: ":") }.to raise_error
    end

    it "should reject more than 3 levels in the tag name" do
      expect { Tag.create(name: "abc:def:ghi:jkl") }.to raise_error
    end

  end

  context "one level name tag" do

    before do
      Tag.destroy_all
      Tag.create(name: "root")
    end

    it "should create a root tag for a one level tag name" do
      (Tag.find_by_name("root").is_root?).should be_true
    end

    it "should raise an error on the creation of a root tag if there's another with the same name" do
      expect { Tag.create(name: "root") }.to raise_error
    end

  end

  context "two levels name tag" do

    before do
      Tag.destroy_all
      Tag.create(name: "root")
      Tag.create(name: "root:1st_lvl_1")
    end

    it "should create a tag under a defined and unique parent name for a 2 levels tag name" do
      Tag.find_by_name("1st_lvl_1").parent.name.should == "root"
    end

    it "should raise an error on the creation of a tag under a defined parent if there's ambiguity on who the parent is" do
      Tag.create(name: "root:1st_lvl_2")
      Tag.create(name: "1st_lvl_1:1st_lvl_1")

      expect { Tag.create(name: "1st_lvl_1:2nd_lvl_1") }.to raise_error
    end

  end

  context "three levels name tag" do

    before do
      Tag.destroy_all
      Tag.create(name: "root")
      Tag.create(name: "root:1st_lvl_1")
      Tag.create(name: "root:1st_lvl_2")
      Tag.create(name: "1st_lvl_2:2nd_lvl_1")
    end

    it "should create a tag under a defined parent referenced by any ancestor for a 3 levels tag name" do
      Tag.create(name: "1st_lvl_2:2nd_lvl_1:3rd_lvl_1")
      created_tag = Tag.find_by_name("3rd_lvl_1")
      parent_tag = created_tag.parent
      parent_tag.name.should == "2nd_lvl_1"
      parent_tag.parent.name.should == "1st_lvl_2"
    end

    it "should raise an error on the creation of a tag referenced by an ancestor if there's ambiguity on who the ancestor is" do
      Tag.create(name: "1st_lvl_1:1st_lvl_2")
      expect { Tag.create(name: "1st_lvl_2:2nd_lvl_1:3rd_lvl_2") }.to raise_error
    end

  end

  it "should return the closest unique ancestor" do
    Tag.destroy_all
    Tag.create(name: "root")
    Tag.create(name: "root:1st_lvl_1")
    Tag.create(name: "root:1st_lvl_2")

    Tag.create(name: "1st_lvl_1:2nd_lvl_1")
    Tag.create(name: "1st_lvl_2:2nd_lvl_1")

    tag = Tag.create(name: "1st_lvl_2:2nd_lvl_1:test_tag")
    tag.unique_ancestor.name.should == "1st_lvl_2"
  end

  context "tag unique name" do

    before do
      Tag.destroy_all
    end

    it "should give me a 1 level name if is root" do
      tag = Tag.create(name: "root")
      tag.unique_name.should == "root"
    end

    it "should give me a 2 levels name if parent is unique" do
      Tag.create(name: "root")
      Tag.create(name: "root:1st_lvl_1")
      tag = Tag.create(name: "1st_lvl_1:2nd_lvl_1")

      tag.unique_name.should == "1st_lvl_1:2nd_lvl_1"
    end

    it "should give me a 3 levels name if parent is not unique" do
      Tag.create(name: "root")
      Tag.create(name: "root:1st_lvl_1")
      Tag.create(name: "root:1st_lvl_2")

      Tag.create(name: "1st_lvl_1:2nd_lvl_1")
      Tag.create(name: "1st_lvl_2:2nd_lvl_1")

      tag = Tag.create(name: "1st_lvl_2:2nd_lvl_1:test_tag")
      tag.unique_name.should == "1st_lvl_2:2nd_lvl_1:test_tag"
    end

  end

end
