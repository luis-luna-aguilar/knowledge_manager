require 'spec_helper'

describe ActAsTaggable do

  class ModuleTestingClass

    attr_accessor :tags

    def initialize
      @tags = Array.new
    end

    def @tags.<< tag
      self.push tag
    end

  end

  before do
    @taggable_instance = ModuleTestingClass.new
    @taggable_instance.extend ActAsTaggable
  end

  it "should construct the list of tags string from the tags related to the instance" do
    Tag.destroy_all
    tags = 3.times.map {FactoryGirl.create(:tag)}
    @taggable_instance.stub(:tags) { tags }

    @taggable_instance.tags_list.should == "#{tags[0].name},#{tags[1].name},#{tags[2].name}"
  end

  it "should set the list of tags from a well formed string for new tags" do
    @taggable_instance.tags_list = "tag-1,tag-2,tag-3"
    (@taggable_instance.tags.map {|tag| tag.name }).should == ["tag-1", "tag-2", "tag-3"]
  end

  it "should set the list of tags from a well formed string for existent tags" do
    Tag.destroy_all
    Tag.create(name: "test")
    
    @taggable_instance.tags_list = "test"
    @taggable_instance.tags_list.should == "test"
  end

  it "should raise an error if the tags list string includes blanks" do
    expect { @taggable_instance.tags_list = "tag-1,,tag-3" }.to raise_error
  end

  it "should raise an error if the tags list is empty" do
    expect { @taggable_instance.tags_list = "" }.to raise_error
    expect { @taggable_instance.tags_list = nil }.to raise_error
  end

end