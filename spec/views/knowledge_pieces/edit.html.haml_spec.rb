require 'spec_helper'

describe "knowledge_pieces/edit" do
  before(:each) do
    @knowledge_piece = assign(:knowledge_piece, stub_model(KnowledgePiece,
      :title => "MyString",
      :body => "MyText"
    ))
  end

  it "renders the edit knowledge_piece form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", knowledge_piece_path(@knowledge_piece), "post" do
      assert_select "input#knowledge_piece_title[name=?]", "knowledge_piece[title]"
      assert_select "textarea#knowledge_piece_body[name=?]", "knowledge_piece[body]"
    end
  end
end
