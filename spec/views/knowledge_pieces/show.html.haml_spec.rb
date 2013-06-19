require 'spec_helper'

describe "knowledge_pieces/show" do
  before(:each) do
    @knowledge_piece = assign(:knowledge_piece, stub_model(KnowledgePiece,
      :title => "Title",
      :body => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
  end
end
