require 'spec_helper'

describe "tags/index" do
  before(:each) do
    assign(:tags, [
      stub_model(Tag,
        :name => "Name"
      ),
      stub_model(Tag,
        :name => "Name 2"
      )
    ])
  end

  it "renders a list of tags" do
    @search = Tag.search(params[:q])
    @tags = @search.result
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 1
    assert_select "tr>td", :text => "Name 2".to_s, :count => 1
  end
end
