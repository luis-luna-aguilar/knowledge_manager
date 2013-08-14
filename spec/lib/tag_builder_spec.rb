require 'spec_helper'

describe TagBuilder do

  context "validations" do

    it "should receive a name" do
      expect { TagBuilder.new(nil) }.to raise_error
    end

    it "shouldn't receive an empty name" do
      expect { TagBuilder.new("") }.to raise_error
    end

    it "should validate the name structure received, so that it doesn't have empty parts" do
      expect { TagBuilder.new(":") }.to raise_error
      expect { TagBuilder.new("a::b") }.to raise_error
    end

    it "should reject more than 3 levels in a tag name received" do
      expect { TagBuilder.new("abc:def:ghi:jkl").create! }.to raise_error
    end

  end

  context "one level name tag" do

    before do
      Tag.destroy_all
      TagBuilder.new("root").create!
    end

    it "should create a root tag for a one level tag name" do
      (Tag.find_by_name("root").is_root?).should be_true
    end

  end

  context "two levels name tag" do

    before do
      Tag.destroy_all
      TagBuilder.new("root").create!
      TagBuilder.new("root:1st_lvl_1").create!
    end

    it "should create a tag under a defined and unique parent name for a 2 levels tag name" do
      Tag.find_by_name("1st_lvl_1").parent.name.should == "root"
    end

    it "should raise an error on the creation of a tag under a defined parent if there's ambiguity on who the parent is" do
      TagBuilder.new("root:1st_lvl_2").create!
      TagBuilder.new("1st_lvl_1:1st_lvl_1").create!
      
      expect { TagBuilder.new("1st_lvl_1:2nd_lvl_1").create! }.to raise_error
    end

  end

  context "three levels name tag" do

    before do
      Tag.destroy_all
      TagBuilder.new("root").create!
      TagBuilder.new("root:1st_lvl_1").create!
      TagBuilder.new("root:1st_lvl_2").create!
      TagBuilder.new("1st_lvl_2:2nd_lvl_1").create!
    end

    it "should create a tag under a defined parent referenced by any unique ancestor for a 3 levels tag name" do
      TagBuilder.new("1st_lvl_2:2nd_lvl_1:3rd_lvl_1").create!
      created_tag = Tag.find_by_name("3rd_lvl_1")
      parent_tag = created_tag.parent
      parent_tag.name.should == "2nd_lvl_1"
      parent_tag.parent.name.should == "1st_lvl_2"
    end

    it "should raise an error on the creation of a tag referenced by an ancestor if there's ambiguity on who the ancestor is" do
      TagBuilder.new("1st_lvl_1:1st_lvl_2").create!
      expect { TagBuilder.new("1st_lvl_2:2nd_lvl_1:3rd_lvl_2").create! }.to raise_error
    end

  end
  
end