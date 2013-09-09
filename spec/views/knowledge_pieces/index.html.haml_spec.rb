require 'spec_helper'

describe "knowledge_pieces/index" do

  before(:each) do
    assign(:knowledge_pieces, [
      stub_model(KnowledgePiece,
        :title => "Title",
        :body => "MyText"
      ),
      stub_model(KnowledgePiece,
        :title => "Title",
        :body => "MyText"
      )
    ])
  end

  it "renders a list of knowledge_pieces" do
    @search = KnowledgePiece.search(params[:q])
    render
    
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end

end