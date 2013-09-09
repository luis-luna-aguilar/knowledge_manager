require 'spec_helper'

describe "articles/index" do

  before(:each) do
    assign(:articles, [
      stub_model(Article,
        :title => "Title",
        :reference_url => "Reference Url"
      ),
      stub_model(Article,
        :title => "Title",
        :reference_url => "Reference Url"
      )
    ])
  end

  it "renders a list of articles" do
    @search = Article.search(params[:q])
    render
    
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title", :count => 2
    assert_select "tr>td", :text => "View original", :count => 2
  end

end